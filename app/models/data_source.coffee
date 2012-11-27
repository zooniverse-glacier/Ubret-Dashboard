AppModel = require 'models/app_model'
Subjects = require 'collections/subject_collection'

class DataSource extends AppModel
  defaults:
    data: []

  fetchData: =>
    if @get('type') is 'external'
      subjects = new Subjects([], {params: @get('params'), url: @get('source').get('url')})
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
    if @get('type') is 'external' then true else false

  dataExtents: (key, ids) =>
    selectedModels = _.map((@get('data').filter (item) ->
      item.id in ids), (model) -> model.toJSON())
    selectedValues = _.pluck(selectedModels, key)
    selectedValues.sort()
    {min: _.first(selectedValues), max: _.last(selectedValues)}

module.exports = DataSource