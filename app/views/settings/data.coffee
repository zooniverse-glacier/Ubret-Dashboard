BaseView = require 'views/base_view'
Manager = require 'modules/manager'
Params = require 'collections/params'
ParamsView = require 'views/params'
SearchTypeView = require 'views/search_type'

class DataSettings extends BaseView
  tagName: 'div'
  className: 'data-settings'
  template: require 'views/templates/settings/data'

  events:
    'click .type-select .external button': 'showExternal'
    'click .type-select .internal button': 'showInternal'
    'change .external .sources': 'onSelectExternalSource'
    'change .internal .sources': 'onSelectInternalSource'
    'change .search-type select': 'onSelectSearchType'
    'click button[name="fetch"]': 'updateModel'

  initialize: ->
    # An allowance for not having the UI block on tool creation.
    @searchTypeView = new SearchTypeView({model: @model.get('data_source')})
    @paramsView = new ParamsView {collection: @model.get('data_source').get('params')}

  render: =>
    opts = {}
    @paramsView.collection = @model.get('data_source').get('params')

    if @model.get('data_source').get('source_type')?
      opts.sourceType = @model.get('data_source').get('source_type')

      switch @model.get('data_source').get('source_type')
        when 'external'
          opts.extSources = Manager.get('sources').getSources()
          if @model.get('data_source').get('source_id')?
            opts.source = @getExternalSource @model.get('data_source').get('source_id')
            opts.search_types = opts.source.get('search_types')
            @searchTypeView.set opts.search_types
        when 'internal'
          @updateValidSourceTools()
          opts.intSources = @intSources
          if @model.get('data_source').get('source_id')?
            opts.source = @model.get('data_source').get('source_id')

    @$el.html @template opts
    @assign
      '.search-type': @searchTypeView
      '.params': @paramsView
    @

  # Fetch the data.
  updateModel: =>
    @model.updateFunc 'data_source:params', @paramsView.setState()
    @model.setupUbretTool()

  # External path
  showExternal: =>
    @model.get('data_source').set
      'source_type': 'external'
      'source_id': null
      'search_type': null
    , {silent: true}
    @render()

  onSelectExternalSource: (e) =>
    unless $(e.currentTarget).val() then return
    @model.get('data_source').set 'source_id', $(e.currentTarget).val(), {silent: true}
    @model.get('data_source').set 'search_type', 0, {silent: true}

    @setParams()
    @render()

  onSelectSearchType: (e) =>
    unless e.currentTarget.value? then return
    @model.get('data_source').set 'search_type', e.currentTarget.value, {silent: true}
    @setParams()
    @render()

  onSetSearchType: (search_type) =>
    # This needs to do something.
    @render()

  setParams: =>
    if @model.get('data_source').get('search_type')?
      @model.get('data_source').get('params').reset()
      @model.get('data_source').get('params').add _.extend({key: key}, value) for key, value of @getExternalSourceParams @model.get('data_source').get('source_id'), {silent: true}

  getExternalSource: (sourceId) ->
    Manager.get('sources').get(sourceId)

  getSearchTypes: (externalSource) ->
    @getExternalSource(externalSource).get('search_types')

  getExternalSourceParams: (externalSource) ->
    @getSearchTypes(externalSource)[@model.get('data_source').get('search_type')].params

  # Internal path
  showInternal: =>
    @model.get('data_source').set 'source_type', 'internal', {silent: true}
    @updateValidSourceTools()
    @render()

  onSelectInternalSource: (e) =>
    @model.get('data_source').set
      'source_id': $(e.currentTarget).val()
      'search_type': null
    , {silent: true}

  updateValidSourceTools: =>
    @intSources = []
    @model.collection.each (tool) =>
      unless @model is tool then  @intSources.push { name: tool.get('name'), id: tool.id }

module.exports = DataSettings