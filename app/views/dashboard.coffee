BaseView = require 'views/base_view'
Tools = require 'collections/tools'
Toolbox = require 'views/toolbox'
ToolWindow = require 'views/tool_window'

class DashboardView extends BaseView
  template: require './templates/layout/dashboard'

  subscriptions:
    'dashboard:initialized': 'onDashboardInit'
    'show-snap': 'drawSnap'
    'stop-snap': 'stopSnap'

  events: 
    'mousedown .tool-window': 'focusWindow'

  initialize: ->
    @toolboxView = new Toolbox
    @toolboxView.on
      'create': @addToolModel
      'remove-tools': @removeTools

  render: =>
    @$el.html @template()
    @assign '.toolbox', @toolboxView
    if @model then @model.tools.each @addTool
    @

  focusWindow: (e) =>
    toolChannel = e.currentTarget.dataset['channel']
    tool = @model.get('tools').find (tool) -> 
      tool.get('channel') is toolChannel
    @model.get('tools').focus tool

  addToolModel: (type) =>
    @model.createTool type

  addTool: (tool) =>
    toolWindow = new ToolWindow
      model: tool
    @$el.append toolWindow.render().el
    toolWindow.postDashboardAppend()

  removeTools: =>
    while @model.tools.length
      @model.tools.first().destroy()
    @model.save()

  onDashboardInit: (@model) =>
    @render()
    @model.on ('add:tool

  stopSnap: =>
    @snap.remove() if @snap

  drawSnap: (direction, dashHeight) =>
    @snap.remove() if @snap
    @$el.append("""<div class="snap #{direction}"></div>""")
    @snap = @$('.snap')
    @snap.css 
      height: if direction in ['top-left', 'top-right', 'bottom-right', 'bottom-left'] then ((dashHeight / 2) - 20) else (dashHeight - 20)
      width: if direction in ['right', 'left', 'top-left', 'top-right', 'bottom-left', 'bottom-right']  then ((window.innerWidth / 2) - 20) else (window.innerWidth - 20)

  _setToolWindow: (toolWindow) ->
    ToolWindow = toolWindow


module.exports = DashboardView