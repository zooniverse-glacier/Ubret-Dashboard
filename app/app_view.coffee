AppHeader = require 'views/app_header'
BaseView = require 'views/base_view'
DashboardView = require 'views/dashboard'
SavedList = require 'views/saved_list'
MyData = require 'views/my_data'
DashboardDialog = require 'views/dashboard_dialog'
User = require 'user'

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
    @dashboardModel = new DashboardModel
      name: name
      project: Manager.get('project')

    @dashboardModel.save().done =>
      @dashboardModel.on 'sync:tools', (tool) =>
        params = new Params [ {key: 'project', val: Manager.get('project')},
                              {key: 'id', val: zooid},
                              {key: 'api', val: if location.port < 1024 then 'api' else 'dev'} ]
        dataSource = 
          source: 2
          search_type: 1
          source_type: 'external'
          params: params


        tool.get('data_source').save(dataSource).done =>
          Manager.get('router').navigate "#/dashboards/#{@dashboardModel.id}", {trigger: true}

      tools = []
      for toolType, index in Toolsets.projects[Manager.get('project')].defaults
        tool =
          tool_type: toolType
          name: "#{toolType}-#{index}"
          channel: "#{toolType}-#{index}"
        tool.settings = settings unless _.isUndefined(settings)
        tools.push tool
      @dashboardModel.get('tools').add tools

  createDashboardFromParams: (name, tools, collection, params) =>
    # this is still pretty ugly
    @dashboardModel = new DashboardModel
      name: name.join(' ')
      project: Manager.get('project')

    @dashboardModel.save().done =>
      @dashboardModel.on 'sync:tools', (tool) =>
        paramsFormatted = new Array
        for param in params
          [key, value...] = param.split('_')
          paramsFormatted.push {key: key, val: value.join('_')}

        dataSource =
          source: parseInt(collection[0])
          search_type: parseInt(collection[1])
          source_type: 'external'
          params: new Params paramsFormatted
        
        tool.get('data_source').save(dataSource) =>
          Manager.get('router').navigate "#/dashboards/#{@dashboardModel.id}", {trigger: true}
        
      toolsFormatted = new Array
      for toolType, index in tools
        toolFormatted = 
          tool_type: toolType
          name: "#{toolType}-#{index}"
          channel: "#{toolType}-#{index}"
        toolsFormatted.push toolFormatted
      @dashboardModel.get('tools').add toolsFormatted

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

    User.current.syncToSpelunker()

  showMyData: =>
    unless @myDataView? then @myDataView = new MyData
    @myDataView.loadCollections()
    @appFocusView = @myDataView
    @render()

module.exports = AppView
