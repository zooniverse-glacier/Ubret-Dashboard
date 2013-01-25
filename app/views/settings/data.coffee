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

  initialize: ->
    @dataSource = @model.get('data_source')
    @channel = @model.get('channel')

    @updateValidSourceTools()

    @searchTypeView = new SearchTypeView({model: @dataSource})
    @paramsView = new ParamsView @dataSource.get('params')

  render: =>
    opts =
      extSources: Manager.get('sources').getSources()
      intSources: @intSources or []

    if @dataSource.get('source_type')?
      opts.sourceType = @dataSource.get('source_type')
      opts.source = @dataSource.get('source')

      switch @dataSource.get('source_type')
        when 'external'
          if @dataSource.get('source')?
            opts.source = @getExternalSource @dataSource.get('source')
            opts.search_types = opts.source.get('search_types')

            @searchTypeView.set opts.search_types
            @setParams()
        when 'internal'
          opts.source = @dataSource.get('source')

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
    @dataSource.set 'source', $(e.currentTarget).val()
    @dataSource.set 'search_type', @getSearchTypes(@dataSource.get('source'))[0].name

    @setParams()
    @render()

  showExternal: =>
    @dataSource.set 'source_type', 'external'
    @render()

  showInternal: =>
    @dataSource.set 'source_type', 'internal'
    @render()

  updateModel: =>
    @dataSource.save()
    @dataSource.fetchData()

  setParams: =>
    if @dataSource.get('search_type')?
      @dataSource.get('params').reset()
      @dataSource.get('params').add _.extend({key: key}, value) for key, value of @getExternalSourceParams @dataSource.get('source')

  getExternalSource: (sourceId) ->
    Manager.get('sources').get(sourceId)

  getSearchTypes: (externalSource) ->
    @getExternalSource(externalSource).get('search_types')

  getExternalSourceParams: (externalSource) ->
    for searchType in @getSearchTypes(externalSource)
      if searchType.name is @dataSource.get('search_type')
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