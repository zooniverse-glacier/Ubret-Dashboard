ToolWindow = require 'views/tool_window'

class DashboardView extends Backbone.View
  tagName: 'div'
  className: 'dashboard'

  render: =>
    @model.get('tools').each @createToolWindow
    @

  createToolWindow: (tool) =>
    toolWindow = new ToolWindow { model: tool }
    @$el.append toolWindow.render().el

  _setToolWindow: (toolWindow) ->
    ToolWindow = toolWindow

module.exports = DashboardView