AppView = require 'views/app_view'
Manager = require 'modules/manager'

Param = require 'models/param'
Params = require 'collections/params'
ParamView = require 'views/param'
ParamsView = require 'views/params'

class DataSettings extends AppView
  tagName: 'div'
  className: 'data-settings'
  template: require './templates/data_settings'

  events:
    'click .type-select a.external' : 'showExternal'
    'click .type-select a.internal' : 'showInternal'
    'change .external-sources': 'onSelectExternalSource'
    'click button[name="fetch"]'    : 'updateModel'

  subscriptions:
    'source:dataReceived': 'updateValidSourceTools'

  initialize: (options) ->
    @dataSource = @model.get('dataSource')
    @channel = @model.get('channel')
    @sourceType = false
    @updateValidSourceTools()

    @params = new Params()
    @paramsView = new ParamsView({collection: @params})

  render: =>
    opts =
      extSources: Manager.get('sources').getSources()
      intSources: @intSources or []
      sourceType: @sourceType

    if @selectedSource
      new_opts =
        search_types: @selectedSource.get('search_types')
        selectedSourceId: @selectedSource.cid
      opts = _.extend new_opts, opts

    @$el.html @template opts

    @assign
      '.params': @paramsView
    @

  # Events
  onSelectExternalSource: (e) =>
    @params.reset()
    @searchTypes = []

    @selectedSource = Manager.get('sources').getByCid($(e.currentTarget).val())
    _.each @selectedSource.get('search_types'), (search_type) =>
      @searchTypes.push search_type

    # Choose first search type as default
    @selectedSearchType = _.first @searchTypes
    _.each @selectedSearchType.params, (param, key) =>
      @params.add _.extend {key: key}, param

    @render()

  showExternal: =>
    @sourceType = 'external'
    @render()

  showInternal: =>
    @sourceType = 'internal'
    @render()

  updateModel: =>
    @dataSource.set('type', @sourceType)

    if @dataSource.get('type') is 'external'
      source_id = @$('select.external-sources').val()
      source = Manager.get('sources').getByCid(source_id)

      # Retrieve params data
      @paramsView.setState()
      @dataSource.set('params', @params)

      # params = new Object
      # @$('.external-settings input').each (index) ->
      #   name = $(this).attr('name')
      #   value = $(this).val()
      #   params[name] = value
      # @dataSource.set 'params', params
    else
      source = @$('select.internal-sources').val()
      
    @dataSource.set('source', source)

  updateValidSourceTools: =>
    @intSources = []
    @model.collection.each (tool) =>
      isValid = @checkToolSource @model, tool, []
      if isValid then @intSources.push { name: tool.get('name'), channel: tool.get('channel') }

  checkToolSource: (source_tool, tool, checkedTools) =>
    if _.isEqual source_tool, tool
      return false

    if _.isUndefined tool.get('dataSource').get('source')
      return false

    if tool.get('dataSource').isExternal()
      return true
    else
      unless _.find checkedTools, ((checkedTool) -> _.isEqual(tool, checkedTool))
        checkedTools.push tool
        chainedTool = tool.collection.find((next_tool) -> tool.get('dataSource').get('source') == next_tool.get('channel'))
        @checkToolSource source_tool, chainedTool, checkedTools
      else
        return false

module.exports = DataSettings