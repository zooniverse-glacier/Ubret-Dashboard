AppHeader = require 'views/app_header'
BaseView = require 'views/base_view'
DashboardModel = require 'models/dashboard'
DashboardView = require 'views/dashboard'
Manager = require 'modules/manager'
SavedList = require 'views/saved_list'
ToolLoader = require 'modules/tool_loader'
User = require 'user'

class AppView extends BaseView
  template: require './views/templates/layout/app'

  subscriptions:
    'dashboard:create': 'createDashboard'
    'router:dashboardCreate': 'createDashboard'
    'router:dashboardRetrieve': 'loadDashboard'
    'router:viewSavedDashboards': 'showSaved'
    'router:index': 'createDashboardView'

  initialize: ->
    @$el.html @template()

    @appHeader = new AppHeader({el: @$('.app-header')})

    # Main area views. Switched out when appropriate.
    @dashboardView = new DashboardView
    User.current?.on 'loaded-dashboards', =>
      @savedListView = new SavedList {collection: User.current.dashboards}

    @appFocusView = @dashboardView

  render: =>
    @assign
      '.app-header': @appHeader
      '.main-focus': @appFocusView
    @

  createDashboard: =>
    @dashboardModel = new DashboardModel
    @dashboardModel.once 'change', =>
      ToolLoader @dashboardModel, @createDashboardView

  loadDashboard: (id) =>
    @dashboardModel = new DashboardModel {id: id}
    @dashboardModel.fetch
      success: => ToolLoader @dashboardModel, @createDashboardView

  createDashboardView: =>
    Backbone.Mediator.publish 'tools:loaded'
    Backbone.Mediator.publish 'dashboard:initialized', @dashboardModel
    @appFocusView = @dashboardView
    @render()

    # @dashboardModel.tools.add
    #   dashboard_id: @dashboardModel.get 'id'
    #   type: 'SubjectViewer'
    #   onInit: (tool) ->
    #     tool.dataSource.set 'source', '4'
    #     tool.dataSource.set 'type', 'external'
    #     tool.dataSource.params.add [
    #       {key: 'project', value: Manager.get 'project'}
    #       {key: 'id', value: Manager.get 'object'}
    #     ]
    #     tool.dataSource.fetchData()

  showSaved: =>
    if typeof @savedListView is 'undefined'
      User.current?.on 'loaded-dashboards', =>
        @savedListView = new SavedList { collection: User.current.dashboards }
        @appFocusView = @savedListView
        @render()
    else
      @appFocusView = @savedListView
      @render()
  
module.exports = AppView
