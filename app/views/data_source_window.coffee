Window = require 'views/window'
ParamsView = require 'views/params'

class DataSourceWindow extends Window
  className: 'tool-window data-source-window'
  manager: require 'modules/manager'
  sourceTemplate: require './templates/data_source_window'

  initialize: ->
    super
    @setParams()
    @paramsView = new ParamsView 
      collection: @model.get('data_source.params')
    @model.on 'change:data_source.search_type', @setParams
    @model.on 'change:data_source.search_type', @render()

  setParams: =>
    if @model.get('data_source.search_type')?
      @model.get('data_source.params').reset()
      params = @searchTypes()[@model.get('data_source.search_type')].params
      console.log @searchTypes()['area']
      for key, value of params
        @model.get('data_source.params').add _.extend({key: key}, value) 

  render: =>
    super
    @paramsView.collection = @model.get('data_source.params')
    console.log @model.get('data_source.params')
    @$('.container').html @sourceTemplate
      source: @model.get('tool_type')
      search_type: @model.get('data_source.search_type')
      search_types: @searchTypes()
    @assign
      '.params' : @paramsView
    @$('.settings').remove()
    @

  searchTypes: =>
    @manager.get('sources')
      .get(@model.get('data_source.source_id')).search_types


module.exports = DataSourceWindow
