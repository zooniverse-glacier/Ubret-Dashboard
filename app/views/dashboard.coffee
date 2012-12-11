BaseView = require 'views/base_view'

ToolWindow = require 'views/tool_window'
Tools = require 'collections/tools'

class DashboardView extends BaseView
  subscriptions:
    'dashboard:initialized': 'onDashboardInit'
    'show-snap' : 'drawSnap'
    'stop-snap' : 'stopSnap'

  render: =>
    if @model
      @model.tools.each @createToolWindow
    @

  createToolWindow: (tool) =>
    console.log @model.tools
    toolWindow = new ToolWindow
      model: tool
      collection: @model.tools
    @$el.append toolWindow.render().el

  addTool: =>
    @createToolWindow @model.tools.last()
    toolChannels = new Array
    @model.tools.each (tool) ->
      toolChannels.push 
        name: tool.get('name')
        channel: tool.get('channel')

  removeTools: =>
    @$el.empty()
    @render()

  onDashboardInit: (model) =>
    @model = model
    @render()
    @model.tools.on 'add', @addTool
    @model.tools.on 'reset', @removeTools

  stopSnap: =>
    @snap.remove() if @snap

  drawSnap: (direction, dashHeight) =>
    console.log direction, dashHeight
    @snap.remove() if @snap
    @$el.append("""<div class="snap #{direction}"></div>""")
    @snap = @$('.snap')
    @snap.css 
      height: if direction in ['top-left', 'top-right', 'bottom-right', 'bottom-left'] then ((dashHeight / 2) - 20) else (dashHeight - 20)
      width: if direction in ['right', 'left', 'top-left', 'top-right', 'bottom-left', 'bottom-right']  then ((window.innerWidth / 2) - 20) else (window.innerWidth - 20)

  _setToolWindow: (toolWindow) ->
    ToolWindow = toolWindow


module.exports = DashboardView