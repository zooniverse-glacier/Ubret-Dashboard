BaseView = require 'views/base_view'

class DashboardView extends BaseView
  toolbox: require 'views/toolbox'
  fqlbox: require 'views/fql_box'
  toolWindow: require 'views/tool_window'
  zooniverseWindow: require 'views/zooniverse_source_window'
  manager: require 'modules/manager'
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
    sources =  @manager.get('sources').config[@model.get('project')].sources
    if tool.get('tool_type') in sources
      @addSourceTool(tool)
    else
      @addUbretTool(tool)

  addUbretTool: (tool) =>
    tool.setupUbretTool()
    toolWindow = new @toolWindow({model: tool})
    @$el.append toolWindow.render().el

  addSourceTool: (tool) =>
    if tool.get('tool_type') is 'Zooniverse'
      sourceWindow = new @zooniverseWindow({model: tool})
    else
      sourceWindow = {}
    @$el.append sourceWindow.render().el

  removeTools: =>
    @model.get('tools').each (tool) -> tool.destroy()

  onDashboardInit: (@model) =>
    @toolboxView.setModel(@model)
    @render()
    @model.on
      'add:tools': @addTool
      'reset:tools': @removeTools

module.exports = DashboardView