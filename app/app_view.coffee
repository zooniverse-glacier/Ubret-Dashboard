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
    User.current?.on 'loaded-dashboards', =>
      @savedListView = new SavedList { collection: User.current.dashboards }

    @appFocusView = @dashboardView

    @$el.html @template()

  render: =>
    @assign
      '.app-header': @appHeader
      '.main-focus': @appFocusView
    @

  continue: =>

  createDashboard: =>
    @dashboardModel = new DashboardModel
    @dashboardModel.on 'change', =>
      window.location.hash = "/dashboards/#{@dashboardModel.id}"
      @createDashboardView()

  loadDashboard: (id) =>
    @dashboardModel = new DashboardModel { id: id }
    fetcher = @dashboardModel.fetch()
    fetcher.success @createDashboardView
    fetcher.success Backbone.Mediator.publish 'dashboard:initialized', @dashboardModel

  createDashboardView: =>
    @appFocusView = @dashboardView
    @render()

  showIndex: =>
    @appFocusView = @dashboardView
    @render()

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
