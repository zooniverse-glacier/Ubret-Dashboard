ToolWindow = require 'views/tool_window'
Tools = require 'collections/tools'

class DashboardView extends Backbone.View
  tagName: 'div'
  className: 'dashboard'

  initialize: ->
    @model?.get('tools').on 'add', @addTool
    @model?.get('tools').on 'reset', @removeTools

  render: =>
    @model.get('tools').each @createToolWindow
    @

  createToolWindow: (tool) =>
    toolWindow = new ToolWindow
      model: tool
      collection: @model.get('tools')
    @$el.append toolWindow.render().el

  addTool: =>
    console.log 'here'
    @createToolWindow @model.get('tools').last()
    toolChannels = new Array
    @model.get('tools').each (tool) ->
      toolChannels.push 
        name: tool.get('name')
        channel: tool.get('channel')

  removeTools: =>
    @$el.empty()

  _setToolWindow: (toolWindow) ->
    ToolWindow = toolWindow

module.exports = DashboardView