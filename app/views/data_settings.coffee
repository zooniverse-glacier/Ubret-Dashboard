BaseView = require 'views/base_view'
Manager = require 'modules/manager'

Params = require 'collections/params'
ParamsView = require 'views/params'
SearchTypeView = require 'views/search_type'
class DataSettings extends BaseView
  tagName: 'div'
  className: 'data-settings'
  template: require './templates/data_settings'

  events:
    'click .type-select .external button' : 'showExternal'
    'click .type-select .internal button' : 'showInternal'
    'change .external .sources': 'onSelectExternalSource'
    'click button[name="fetch"]'    : 'updateModel'

  subscriptions:
    'source:dataReceived': 'updateValidSourceTools'

  initialize: (options) ->
    @dataSource = @model.dataSource
    @channel = @model.get('channel')
    @sourceType = @dataSource.get('type') or false
    @selectedSource = Manager.get('sources').get(@dataSource.get('source')) if typeof @dataSource.get('source') isnt 'undefined'
    @updateValidSourceTools()

    @searchTypeView = new SearchTypeView()
    @params = @dataSource.params
    @paramsView = new ParamsView({collection: @params})

    @searchTypeView.on 'searchType:typeSelected', @onSetSearchType

  render: =>
    opts =
      extSources: Manager.get('sources').getSources()
      intSources: @intSources or []
      sourceType: @sourceType

    if @sourceType is 'internal'
      opts['source'] = @model.dataSource.get('source')

    if @selectedSource
      new_opts =
        search_types: @selectedSource.get('search_types')
        selectedSourceId: @selectedSource.id
      opts = _.extend new_opts, opts

    @$el.html @template opts

    @assign
      '.search-type': @searchTypeView
      '.params': @paramsView
    @

  # Events
  onSetSearchType: (search_type) =>
    @selectedSearchType = _.find @searchTypes, (type) -> type.name is search_type
    @setParams()
    @render()

  onSelectExternalSource: (e) =>
    @searchTypes = []

    @selectedSource = Manager.get('sources').get($(e.currentTarget).val())
    _.each @selectedSource.get('search_types'), (search_type) =>
      @searchTypes.push search_type

    @searchTypeView.set @searchTypes

    # Choose first search type as default
    @selectedSearchType = _.first @searchTypes
    @setParams()
    @render()

  showExternal: (e) =>
    @sourceType = 'external'
    @render()

  showInternal: (e) =>
    @sourceType = 'internal'
    @render()

  updateModel: =>
    @dataSource.set('type', @sourceType)

    if @dataSource.get('type') is 'external'
      source_id = @$('.external .sources').val()
      source = source_id

      # Retrieve params data
      @paramsView.setState()
      @dataSource.set('params', @params)
    else
      source = @$('.internal .sources').val()
      
    @dataSource.set('source', source)
    @dataSource.fetchData()

  setParams: =>
    @params.reset()
    _.each @selectedSearchType.params, (param, key) =>
      @params.add _.extend {key: key}, param

  updateValidSourceTools: =>
    @intSources = []
    @model.collection?.each (tool) =>
      isValid = @checkToolSource @model, tool, []
      if isValid then @intSources.push { name: tool.get('name'), channel: tool.get('channel') }

  checkToolSource: (source_tool, tool, checkedTools) =>
    if _.isEqual source_tool, tool
      return false

    if _.isUndefined tool.dataSource.get('source')
      return false

    if tool.dataSource.isExternal()
      return true
    else
      unless _.find checkedTools, ((checkedTool) -> _.isEqual(tool, checkedTool))
        checkedTools.push tool
        chainedTool = tool.collection.find((next_tool) -> tool.dataSource.get('source') == next_tool.get('channel'))
        @checkToolSource source_tool, chainedTool, checkedTools
      else
        return false

module.exports = DataSettings