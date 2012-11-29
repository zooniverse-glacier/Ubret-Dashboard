AppModel = require 'models/app_model'
Subjects = require 'collections/subject_collection'
Manager = require 'modules/manager'

class DataSource extends AppModel
  defaults:
    data: []

  urlRoot: =>
    "/dashboards/#{@get('tools').dashboardId}/tools/#{@toolId}/data_sources"

  toJSON: ->
    json = new Object
    json[key] = value for key, value of @attributes when key isnt 'tools'
    json

  fetchData: =>
    if @get('type') is 'external'
      url = Manager.get('sources').get(@get('source')).get('url')
      subjects = new Subjects([], {params: @get('params'), url: url })
      subjects.url()
      @set('data', subjects)
      @get('data').fetch
        success: =>
          @triggerEvent 'source:dataReceived'
    else if @get('type') is 'internal'
      source = @get('tools').find (tool) =>
        tool.get('channel') == @get('source')
      @set('data', source.get('dataSource').get('data'))
      @triggerEvent 'source:dataReceived'
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