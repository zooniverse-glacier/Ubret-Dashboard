BaseView = require 'views/base_view'

class DashboardView extends BaseView
  toolbox: require 'views/toolbox'
  fqlbox: require 'views/fql_box'
  toolWindow: require 'views/tool_window'
  zooniverseWindow: require 'views/zooniverse_source_window'
  dataSourceWindow: require 'views/data_source_window'
  manager: require 'modules/manager'
  user: require 'lib/user'
  template: require './templates/layout/dashboard'
  tutorials: require 'tutorials'
  warnDialog: require 'views/non_owner_dialog'

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
      sourceWindow = new @dataSourceWindow({model: tool})
    @$el.append sourceWindow.render().el

  removeTools: =>
    sources = @model.get('tools').filter((t) -> 
      t.get('data_source.source_type') isnt 'internal' or _.isNull(t.get('data_source.source_id')))
    _.each sources, (s) -> s.destroy()

  endTutorial: =>
    @user.current.finishTutorial()

  startTutorial: =>
    tutorial = @tutorials[@manager.get('project')]
    tutorial.el.bind('end-tutorial', @endTutorial)
    tutorial.start()

  warnNonOwner: =>
    dialog = new @warnDialog()
    $('body').append dialog.render().el

  onDashboardInit: (@model) =>
    @toolboxView.setModel(@model)
    @render()
    if @user.current? and @user.current.id isnt @model.get('user').id
      @$el.on 'click', @warnNonOwner
    else if @model.get('name') is 'Tutorial'
      @$el.off 'click', @warnNonOwner
      @startTutorial()
    else
      @$el.off 'click', @warnNonOwner
    @model.on
      'add:tools': @addTool
      'reset:tools': @removeTools

module.exports = DashboardView