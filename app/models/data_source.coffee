BaseModel = require 'models/base_model'
Subjects = require 'collections/subject_collection'
Manager = require 'modules/manager'
Params = require 'collections/params'
corsSync = require 'sync'

class DataSource extends BaseModel
  sync: corsSync

  urlRoot: =>
    "/dashboards/#{@tools.dashboardId}/tools/#{@toolId}/data_sources"

  toJSON: ->
    json = new Object
    json[key] = value for key, value of @attributes
    json

  initialize: ->
    @params = new Params(@get('params')) if typeof @get('params') isnt 'undefined'
    @params = @params or new Params()

  fetchData: =>
    if @get('type') is 'external'
      url = Manager.get('sources').get(@get('source')).get('url')
      @data = new Subjects([], {params: @params, url: url })
      @data.fetch
        success: =>
          @triggerEvent 'source:dataReceived'
          @save()
    else if @get('type') is 'internal'
      @source = @tools.find (tool) =>
        tool.get('channel') == @get('source')
      @data = []
      @triggerEvent 'source:dataReceived'
      @save()
    else
      throw 'unknown source type'

  isExternal: =>
    (@get('type') is 'external')

  isInternal: =>
    (@get('type') is 'internal')

  isReady: =>
    (@isInternal() and (not _.isUndefined(@source))) or (@isExternal() and (not _.isUndefined(@data)))

  sourceName: =>
    if @isExternal()
      name = Manager.get('sources').get(@get('source')).get('name')
    else if @isInternal()
      name = @tools.find((tool) => tool.get('channel') == @get('source')).get('name') 
    else
      name = ''
    return name

  dataExtents: (key, ids) =>
    selectedModels = _.map((@data.filter (item) ->
      item.id in ids), (model) -> model.toJSON())
    selectedValues = _.pluck(selectedModels, key)
    selectedValues.sort()
    {min: _.first(selectedValues), max: _.last(selectedValues)}

module.exports = DataSource