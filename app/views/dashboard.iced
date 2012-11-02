ToolWindow = require 'views/tool_window'

class DashboardView extends Backbone.View
  tagName: 'div'
  className: 'dashboard'

  initialize: ->
    @model?.on 'change', @addTool

  render: =>
    @model.get('tools').each @createToolWindow
    @

  createToolWindow: (tool) =>
    toolWindow = new ToolWindow { model: tool }
    @$el.append toolWindow.render().el

  addTool: =>
    if @model.hasChanged('tools')
      @createToolWindow @model.get('tools').last()

  _setToolWindow: (toolWindow) ->
    ToolWindow = toolWindow

module.exports = DashboardView