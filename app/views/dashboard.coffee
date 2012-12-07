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
    Backbone.Mediator.subscribe 'show-snap', @drawSnap
    Backbone.Mediator.subscribe 'stop-snap', @stopSnap

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

  stopSnap: =>
    @snap.remove() if @snap

  drawSnap: (direction, dashHeight) =>
    @snap.remove() if @snap
    @$el.append("""<div class="snap #{direction}"></div>""")
    @snap = @$('.snap')
    @snap.css 
      height: dashHeight - 20
      width: if direction is 'left' or direction is 'right' then ((window.innerWidth / 2) - 20) else (window.innerWidth - 20)

  _setToolWindow: (toolWindow) ->
    ToolWindow = toolWindow


module.exports = DashboardView