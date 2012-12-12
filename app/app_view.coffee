User = require 'user'

BaseView = require 'views/base_view'

DashboardModel = require 'models/dashboard'
DashboardView = require 'views/dashboard'

AppHeader = require 'views/app_header'
SavedList = require 'views/saved_list'

class AppView extends BaseView
  template: require './views/templates/layout/app'

  subscriptions:
    'dashboard:create': 'createDashboard'
    'router:dashboardCreate': 'createDashboard'
    'router:dashboardRetrieve': 'loadDashboard'
    'router:viewSavedDashboards': 'showSaved'
    'router:index': 'showIndex'

  initialize: ->
    @appHeader = new AppHeader

    # Main area views. Switched out when appropriate.
    @dashboardView = new DashboardView
    @savedListView = new SavedList { collection: User.current.dashboards }

    @appFocusView = @dashboardView

    @$el.html @template()

  render: =>
    @assign
      '.app-header': @appHeader
      '.main-focus': @appFocusView
    @

  createDashboard: =>
    @dashboardModel = new DashboardModel
    @createDashboardView()

  loadDashboard: (id) =>
    @dashboardModel = new DashboardModel { id: id }
    fetcher = @dashboardModel.fetch()
    fetcher.success @createDashboardView
    fetcher.success Backbone.Mediator.publish 'dashboard:initialized', @dashboardModel

  createDashboardView: =>
    @appFocusView = @dashboardView
    @render()

  addTool: (toolType) =>
    @dashboardModel.createTool toolType

  removeTools: =>
    @dashboardModel.removeTools()

  showIndex: =>
    @appFocusView = @dashboardView
    @render()

  showSaved: =>
    @appFocusView = @savedListView
    @render()
  
module.exports = AppView
