BaseView = require 'views/base_view'

class DashboardView extends BaseView
  toolbox: require 'views/toolbox'
  toolWindow: require 'views/tool_window'
  template: require './templates/layout/dashboard'

  subscriptions:
    'dashboard:initialized': 'onDashboardInit'
    'show-snap': 'drawSnap'
    'stop-snap': 'stopSnap'

  events: 
    'mousedown .tool-window': 'focusWindow'

  initialize: ->
    @toolboxView = new @toolbox
    @toolboxView.on
      'create': @addToolModel
      'remove-tools': @removeTools

  render: =>
    @$el.html @template()
    @assign '.toolbox', @toolboxView
    @model?.get('tools').each @addTool
    @

  focusWindow: (e) =>
    id = e.currentTarget.dataset.id
    tool = @model.get('tools').get id
    @model.get('tools').focus tool

  addToolModel: (type) =>
    @model.createTool type

  addTool: (tool) =>
    toolWindow = new @toolWindow
      model: tool
    @$el.append toolWindow.render().el

  removeTools: =>
    @model.get('tools').each (tool) -> tool.destroy()

  onDashboardInit: (@model) =>
    @toolboxView.model = @model
    @model.get('tools').each (tool) -> tool.createUbretTool()
    @render()
    @model.get('tools').each (tool) -> tool.setupUbretTool()
    @model.on
      'add:tools': @addTool
      'reset:tools': @removeTools

  stopSnap: =>
    @snap.remove() if @snap

  drawSnap: (direction, dashHeight) =>
    @snap.remove() if @snap
    @$el.append("""<div class="snap #{direction}"></div>""")
    @snap = @$('.snap')
    @snap.css 
      height: if direction in ['top-left', 'top-right', 'bottom-right', 'bottom-left'] then ((dashHeight / 2) - 20) else (dashHeight - 20)
      width: if direction in ['right', 'left', 'top-left', 'top-right', 'bottom-left', 'bottom-right']  then ((window.innerWidth / 2) - 20) else (window.innerWidth - 20)


module.exports = DashboardView