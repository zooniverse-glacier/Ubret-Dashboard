BaseView = require 'views/base_view'

class DashboardView extends BaseView
  toolbox: require 'views/toolbox'
  fqlbox: require 'views/fql_box'
  toolWindow: require 'views/tool_window'
  template: require './templates/layout/dashboard'

  subscriptions:
    'dashboard:initialized': 'onDashboardInit'

  initialize: ->
    @toolboxView = new @toolbox
    @toolboxView.on
      'create': @addToolModel
      'remove-tools': @removeTools

  render: =>
    @$el.html @template()
    @assign '.toolbox', @toolboxView
    @model?.get('tools').each @addTool
    @fqlboxView = new @fqlbox if Ubret?.Fql? and !@fqlboxView?
    @assign '.fql-box', @fqlboxView if @fqlboxView?
    @

  addToolModel: (type) =>
    @model.createTool type

  addTool: (tool) =>
    tool.createUbretTool()
    tool.setupUbretTool()
    toolWindow = new @toolWindow
      model: tool
    @$el.append toolWindow.render().el

  removeTools: =>
    @model.get('tools').each (tool) -> tool.destroy()

  onDashboardInit: (@model) =>
    @toolboxView.model = @model
    @render()
    @model.on
      'add:tools': @addTool
      'reset:tools': @removeTools

module.exports = DashboardView