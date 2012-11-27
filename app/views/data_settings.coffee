Manager = require 'modules/manager'

class DataSettings extends Backbone.View
  tagName: 'div'
  className: 'data-settings'
  template: require './templates/data_settings'

  events:
    'click .type-select a.external' : 'showExternal'
    'click .type-select a.internal' : 'showInternal'
    'click button[name="fetch"]'    : 'updateModel'

  subscriptions:
    'source:dataReceived': 'updateValidSourceTools'

  initialize: (options) ->
    @dataSource = @model.get('dataSource')
    @channel = @model.get('channel')
    @sourceType = false
    @updateValidSourceTools()

    # Data events
    @dataSource.on 'change:source', @render
    # @dataSource.on 'change:params', @setParams

  render: =>
    @$el.html @template
      extSources: Manager.get('sources').getSources()
      intSources: @intSources or []
      source: @dataSource?.get('source')
      sourceType: @sourceType
    @

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
      params = new Object
      @$('.external-settings input').each (index) ->
        name = $(this).attr('name')
        value = $(this).val()
        params[name] = value
      @dataSource.set 'params', params
    else
      source = @$('select.internal-sources').val()
      
    @dataSource.set('source', source)

  updateValidSourceTools: =>
    @intSources = []
    @model.collection.each (tool) =>
      isValid = @checkToolSource @model, tool, []
      if isValid then @intSources.push { name: tool.get('name'), channel: tool.get('channel') }
    @render()

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