BaseView = require 'views/base_view'
Manager = require 'modules/manager'
Params = require 'collections/params'
ParamsView = require 'views/params'
SearchTypeView = require 'views/search_type'

class DataSettings extends BaseView
  tagName: 'div'
  className: 'data-settings'
  template: require 'views/templates/data_settings'

  events:
    'click .type-select .external button': 'showExternal'
    'click .type-select .internal button': 'showInternal'
    'change .external .sources': 'onSelectExternalSource'
    'click button[name="fetch"]': 'updateModel'

  subscriptions:
    'source:dataReceived': 'updateValidSourceTools'

  initialize: (options) ->
    @channel = @model.get('channel')
    @sourceType = @model.get('data_source').get('source_type') or false
    @selectedSource = Manager.get('sources').get(@model.get('data_source').get('source')) if typeof @model.get('data_source').get('source') isnt 'undefined'
    @updateValidSourceTools()

    @searchTypeView = new SearchTypeView()
    @params = @model.get('data_source').get('params')
    @paramsView = new ParamsView @params

    @searchTypeView = new SearchTypeView({model: @model.get('data_source')})
    @paramsView = new ParamsView @model.get('data_source').get('params')

  render: =>
    opts =
      extSources: Manager.get('sources').getSources()
      intSources: @intSources or []

    if @model.get('data_source').get('source_type')?
      opts.sourceType = @model.get("data_source").get('source_type')
      opts.source = @model.get('data_ource').get('source')

      switch @model.get('data_source').get('source_type')
        when 'external'
          if @model.get('data_source').get('source')?
            opts.source = @getExternalSource @model.get('data_source').get('source')
            opts.search_types = opts.source.get('search_types')
            @searchTypeView.set opts.search_types
            @setParams()
        when 'internal'
          opts.source = @model.get('data_source').get('source')

    @$el.html @template opts
    @assign
      '.search-type': @searchTypeView
      '.params': @paramsView
    @

  # Events
  onSetSearchType: (search_type) =>
    # This needs to be refactored.

    # @selectedSearchType = _.find @searchTypes, (type) -> type.name is search_type
    # @setParams()
    @render()

  onSelectExternalSource: (e) =>
    unless $(e.currentTarget).val() then return
    @model.get('data_source').set 'source', $(e.currentTarget).val()
    @model.get('data_source').set 'search_type', @getSearchTypes(@model.get('data_source').get('source'))[0].name

    @setParams()
    @render()

  showExternal: =>
    @model.get('data_source').set 'source_type', 'external'
    @render()

  showInternal: =>
    @model.get('data_source').set 'source_type', 'internal'
    @render()

  updateModel: =>
    @model.get('data_source').save()
    @model.get('data_source').fetchData()

  setParams: =>
    if @model.get('data_source').get('search_type')?
      @model.get('data_source').get('params').reset()
      @model.get('data_source').get('params').add _.extend({key: key}, value) for key, value of @getExternalSourceParams @model.get('data_source').get('source')

  getExternalSource: (sourceId) ->
    Manager.get('sources').get(sourceId)

  getSearchTypes: (externalSource) ->
    @getExternalSource(externalSource).get('search_types')

  getExternalSourceParams: (externalSource) ->
    for searchType in @getSearchTypes(externalSource)
      if searchType.name is @model.get('data_source').get('search_type')
        return searchType.params

  updateValidSourceTools: =>
    @intSources = []
    @model.collection?.each (tool) =>
      isValid = @checkToolSource @model, tool, []
      if isValid then @intSources.push { name: tool.get('name'), channel: tool.get('channel') }

  checkToolSource: (source_tool, tool, checkedTools) =>
    if _.isEqual source_tool, tool
      return false

    if _.isUndefined tool.get('data_source').get('source')
      return false

    if tool.get('data_source').isExternal()
      return true
    else
      unless _.find checkedTools, ((checkedTool) -> _.isEqual(tool, checkedTool))
        checkedTools.push tool
        chainedTool = tool.collection.find((next_tool) -> tool.get('data_source').get('source') == next_tool.get('channel'))
        @checkToolSource source_tool, chainedTool, checkedTools
      else
        return false

module.exports = DataSettings