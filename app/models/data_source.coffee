AppModel = require 'models/app_model'
Subjects = require 'collections/subject_collection'
Manager = require 'modules/manager'
Params = require 'collections/params'
corsSync = require 'sync'

class DataSource extends AppModel
  defaults:
    data: []

  parse: (response) ->
    delete response.data if response.data
    response

  sync: corsSync

  urlRoot: =>
    "/dashboards/#{@get('tools').dashboardId}/tools/#{@toolId}/data_sources"

  toJSON: ->
    console.log @attributes
    json = new Object
    json[key] = value for key, value of @attributes when key isnt 'tools'
    json

  initialize: ->
    @params = new Params(@get('params')) if typeof @get('params') isnt 'undefined'
    @params = @params or new Params()

  fetchData: =>
    if @get('type') is 'external'
      url = Manager.get('sources').get(@get('source')).get('url')
      subjects = new Subjects([], {params: @get('params'), url: url })
      subjects.url()
      @save('data', subjects)
      @get('data').fetch
        success: =>
          @triggerEvent 'source:dataReceived'
          @save()
    else if @get('type') is 'internal'
      source = @get('tools').find (tool) =>
        tool.get('channel') == @get('source')
      @save('data', source.dataSource.get('data'))
      @triggerEvent 'source:dataReceived'
      @save()
    else
      throw 'unknown source type'

  isExternal: =>
    (@get('type') is 'external')

  dataExtents: (key, ids) =>
    selectedModels = _.map((@get('data').filter (item) ->
      item.id in ids), (model) -> model.toJSON())
    selectedValues = _.pluck(selectedModels, key)
    selectedValues.sort()
    {min: _.first(selectedValues), max: _.last(selectedValues)}

module.exports = DataSource