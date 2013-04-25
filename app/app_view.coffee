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
  template: require 'views/templates/layout/app'
  loadingTemplate: require 'views/templates/loading'

  subscriptions:
    'dashboard:create'                  : 'createDashboardFromDialog'
    'dashboard:fork'                    : 'forkDashboard'
    'router:index'                      : 'index'
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

  loadUbretTools: =>
    ToolLoader @dashboardModel, @createDashboardView

  forkDashboard: =>
    @dashboardModel.fork().done (response) =>
      @dashboardModel = new DashboardModel response
      @loadUbretTools()

  createDashboardFromDialog: =>
    dashboardDialog = new DashboardDialog { parent: @ }
    $('body').append dashboardDialog.render().el

  createTools: (tools, dataSource, settings=null) ->
    toolsFormat = []
    _.each(tools, (toolType, index) ->
      tool = 
        tool_type: toolType
        name: "#{toolType}-#{index}"
        data_source: dataSource
      tool.settings = settings if settings?
      toolsFormat.push tool)
    toolsFormat

  createDashboard: (name, tools=[], project=null) ->
    Manager.set 'project', project if project
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

    @dashboardModel = @createDashboard(name.join(' '), toolsFormat)

    @dashboardModel.save().done =>
      @navigateToDashboard()

  loadDashboard: (id) =>
    @$('.main-focus').html @loadingTemplate()
    @dashboardModel = new DashboardModel {id: id}
    @dashboardModel.fetch().then @loadUbretTools, =>
      delete @dashboardModel
      Manager.get('router').navigate '', {trigger: true}

  switchView: (view) =>
    @appFocusView?.$el.empty()
    @appFocusView = view
    @render()

  createDashboardView: =>
    @switchView(@dashboardView)
    Backbone.Mediator.publish 'dashboard:initialized', @dashboardModel

  showSaved: =>
    unless @savedListView? 
      @savedListView = new SavedList 
        collection: User.current.dashboards
    @switchView(@savedListView)
    User.current.getDashboards()

  showMyData: =>
    unless @myDataView? then @myDataView = new MyData
    @myDataView.loadCollections()
    @switchView(@myDataView)

  navigateToDashboard: (trigger=true) =>
    url = "#/dashboards/#{Manager.get('project')}/#{@dashboardModel.id}"
    Manager.get('router').navigate url, {trigger: trigger}

module.exports = AppView
