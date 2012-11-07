ToolWindow = require 'views/tool_window'

class DashboardView extends Backbone.View
  tagName: 'div'
  className: 'dashboard'

  initialize: ->
    @model?.get('tools').on 'add', @addTool

  render: =>
    @model.get('tools').each @createToolWindow
    @

  createToolWindow: (tool) =>
    toolWindow = new ToolWindow { model: tool }
    @$el.append toolWindow.render().el

  addTool: =>
    @createToolWindow @model.get('tools').last()
    toolChannels = new Array
    @model.get('tools').each (tool) ->
      toolChannels.push 
        name: tool.get('name')
        channel: tool.get('channel')
    Backbone.Mediator.publish('all-tools', toolChannels)

  _setToolWindow: (toolWindow) ->
    ToolWindow = toolWindow

module.exports = DashboardView