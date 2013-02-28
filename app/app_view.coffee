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
    'router:index'                      : 'render'
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

  createDashboardFromZooid: (name, zooid, settings) ->
    params = [ {key: 'id', val: zooid} ]

    dataSource = 
      source: '1'
      search_type: 0
      source_type: 'external'
      params: params

    tools = []
    for toolType, index in Toolsets.projects[Manager.get('project')].defaults
      tool =
        tool_type: toolType
        name: "#{toolType}-#{index}"
        data_source: dataSource
      tool.settings = settings unless _.isUndefined(settings)
      tools.push tool

    @dashboardModel = new DashboardModel
      name: name
      project: Manager.get('project')
      tools: tools
    
    @dashboardModel.save().done =>
      Manager.get('router').navigate "#/dashboards/#{@dashboardModel.id}", {trigger: true}

  createDashboardFromParams: (name, tools, collection, params) =>
    paramsFormatted = new Array
    for param in params
      [key, value...] = param.split('_')
      paramsFormatted.push {key: key, val: value.join('_')}

    dataSource =
      source: parseInt(collection[0])
      search_type: parseInt(collection[1])
      source_type: 'external'
      params: paramsFormatted

    toolsFormatted = new Array
    for toolType, index in tools
      toolFormatted = 
        tool_type: toolType
        name: "#{toolType}-#{index}"
        data_source: dataSource
      toolsFormatted.push toolFormatted

    @dashboardModel = new DashboardModel
      name: name.join(' ')
      project: Manager.get('project')
      tools: toolsFormatted

    @dashboardModel.save().done =>
      Manager.get('router').navigate "#/dashboards/#{@dashboardModel.id}", {trigger: true}

  loadDashboard: (id) =>
    @dashboardModel = new DashboardModel {id: id}
    @dashboardModel.fetch
      success: => ToolLoader @dashboardModel, @createDashboardView
      error: =>
        delete @dashboardModel
        Manager.get('router').navigate '', {trigger: true}

  createDashboardView: =>
    @appFocusView = @dashboardView
    @render()
    Manager.get('router').navigate "#/dashboards/#{@dashboardModel.id}", {trigger: false}
    @dashboardModel.get('tools').loadTools()
    Backbone.Mediator.publish 'dashboard:initialized', @dashboardModel

  showSaved: =>
    unless @savedListView? then @savedListView = new SavedList
    User.current.once 'loaded-dashboards', =>
      @savedListView.collection = User.current.dashboards
      @appFocusView = @savedListView
      @render()
    User.current.getDashboards()

  showMyData: =>
    unless @myDataView? then @myDataView = new MyData
    @myDataView.loadCollections()
    @appFocusView = @myDataView
    @render()

module.exports = AppView
