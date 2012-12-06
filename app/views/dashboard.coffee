BaseView = require 'views/base_view'

ToolWindow = require 'views/tool_window'
Tools = require 'collections/tools'

class DashboardView extends BaseView

  subscriptions:
    'dashboard:initialized': 'onDashboardInit'

  render: =>
    if @model
      @model.get('tools').each @createToolWindow
    @

  createToolWindow: (tool) =>
    toolWindow = new ToolWindow
      model: tool
      collection: @model.get('tools')
    @$el.append toolWindow.render().el

  addTool: =>
    @createToolWindow @model.get('tools').last()
    toolChannels = new Array
    @model.get('tools').each (tool) ->
      toolChannels.push 
        name: tool.get('name')
        channel: tool.get('channel')

  removeTools: =>
    @$el.empty()

  onDashboardInit: (model) =>
    @model = model
    @model.get('tools').on 'add', @addTool
    @model.get('tools').on 'reset', @removeTools

  _setToolWindow: (toolWindow) ->
    ToolWindow = toolWindow

module.exports = DashboardView