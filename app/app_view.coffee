AppHeader = require 'views/app_header'
BaseView = require 'views/base_view'
DashboardView = require 'views/dashboard'
SavedList = require 'views/saved_list'
MyData = require 'views/my_data'
DashboardDialog = require 'views/dashboard_dialog'
User = require 'lib/user'

Manager = require 'modules/manager'
ToolLoader = require 'modules/tool_loader'

DashboardModel = require 'models/dashboard'
Params = require 'collections/params'

Toolsets  = require 'config/toolset_config'

class AppView extends BaseView
  template: require './views/templates/layout/app'

  subscriptions:
    'dashboard:create'                  : 'createDashboardFromDialog'
    'dashboard:fork'                    : 'forkDashboard'
    'router:index'                      : 'index'
    'router:dashboardCreate'            : 'createDashboard'
    'router:dashboardCreateFromParams'  : 'createDashboardFromParams'
    'router:dashboardCreateFromZooid'   : 'createDashboardFromZooid'
    'router:dashboardRetrieve'          : 'loadDashboard'
    'router:viewSavedDashboards'        : 'showSaved'
    'router:myData'                     : 'showMyData'

  initialize: ->
    @$el.html @template()
    @appHeader = new AppHeader({el: @$('.app-header')})
    @dashboardView = new DashboardView
    @appHeader.switch.on 'project-change', @projectChange

    # Main area views. Switched out when appropriate.
    @appFocusView = null

  render: =>
    unless @appFocusView?
      @assign
        '.app-header': @appHeader
    else
      @assign
        '.app-header': @appHeader
        '.main-focus': @appFocusView
    @

  index: =>
    @$('.main-focus').empty()
    @appFocusView = null
    @render()

  projectChange: =>
    User.current.getDashboards()
    if @appFocusView is @dashboardView
      Manager.get('router').navigate("#/my_dashboards", {trigger: true})
    else
      @appFocusView.render()

  forkDashboard: =>
    @dashboardModel.fork().done (response) =>
      @dashboardModel = new DashboardModel response
      ToolLoader @dashboardModel, @createDashboardView

  createDashboardFromDialog: =>
    dashboardDialog = new DashboardDialog { parent: @ }
    $('body').append dashboardDialog.render().el

  createDashboard: (name, project) ->
    Manager.set 'project', project
    @dashboardModel = new DashboardModel {name: name, project: project}
    @dashboardModel.save().done =>
      ToolLoader @dashboardModel, @createDashboardView
    return @dashboardModel

  createTools: (tools, dataSource, settings=null) ->
    _.each(tools, (toolType, index) ->
      tool = 
        tool_type: toolType
        name: "#{toolType}-#{index}"
        data_source: dataSource
      tool.settings = settings if settings?)

  createDashboard: (name, tools, project=null) ->
    new DashboardModel
      name: name
      project: (project or Manager.get('project'))
      tools: tools

  createDashboardFromZooid: (name, zooid, settings) ->
    params = [ {key: 'id', val: zooid} ]

    dataSource = 
      source_id: '1'
      search_type: 0
      source_type: 'external'
      params: params

    toolset = Toolsets.projects[Manager.get('project')].defaults
    tools = @createTools(toolset, dataSource, settings)

    @dashboardModel = @createDashboard(name, tools)
    
    @dashboardModel.save().done =>
      @navigateToDashboard()

  createDashboardFromParams: (name, tools, collection, params) =>
    paramsFormatted = new Array
    for param in params
      [key, value...] = param.split('_')
      paramsFormatted.push {key: key, val: value.join('_')}

    dataSource =
      source_id: collection[0]
      search_type: parseInt(collection[1])
      source_type: 'external'
      params: paramsFormatted

    toolsFormat = @createTools(tools, dataSource)

    @dashboardModel = @createDashboard(name, toolsFormat)

    @dashboardModel.save().done =>
      @navigateToDashboard()

  loadDashboard: (id) =>
    @dashboardModel = new DashboardModel {id: id}
    @dashboardModel.fetch().then
      => ToolLoader @dashboardModel, @createDashboardView
      error: =>
        delete @dashboardModel
        Manager.get('router').navigate '', {trigger: true}

  createDashboardView: =>
    @appFocusView = @dashboardView
    @navigateToDashboard(false)
    @render()
    Backbone.Mediator.publish 'dashboard:initialized', @dashboardModel

  showSaved: =>
    unless @savedListView? 
      @savedListView = new SavedList 
        collection: User.current.dashboards
    @switchView(@savedListView)
    @render()
    User.current.getDashboards()

  showMyData: =>
    unless @myDataView? then @myDataView = new MyData
    @myDataView.loadCollections()
    @switchView(@myDataView)
    @render()

  navigateToDashboard: (trigger=true) =>
    url = "#/dashboards/#{Manager.get('project')}/#{@dashboardModel.id}"
    Manager.get('router').navigate url, {trigger: trigger}

module.exports = AppView
