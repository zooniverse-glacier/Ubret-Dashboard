User = require 'user'

BaseView = require 'views/base_view'

DashboardModel = require 'models/dashboard'
DashboardView = require 'views/dashboard'

AppHeader = require 'views/app_header'
Toolbox = require 'views/toolbox'
SavedList = require 'views/saved_list'

class AppView extends BaseView
  template: require './views/templates/layout/app'

  subscriptions:
    'dashboard:create': 'createDashboard'

  initialize: ->
    @appHeader = new AppHeader
    @toolbox = new Toolbox

    # Main area views. Switched out when appropriate.
    @dashboardView = new DashboardView
    @savedListView = new SavedList

    @appFocusView = @dashboardView

    @toolbox.on 'create', @addTool
    @toolbox.on 'remove-tools', @removeTools

  render: =>
    @$el.html @template()
    @assign
      '.app-header': @appHeader
      '.toolbox': @toolbox
      '.main-focus': @appFocusView
    @

  createDashboard: (id) =>
    if typeof id is 'undefined'
      @dashboardModel = new DashboardModel
      @createDashboardView()
    else
      @dashboardModel = new DashboardModel { id: id }
      fetcher = @dashboardModel.fetch()
      fetcher.success Backbone.Mediator.publish 'dashboard:initialized', @dashboardModel
      fetcher.success @createDashboardView

  createDashboardView: =>
    @appFocusView = @dashboardView

  addTool: (toolType) =>
    @dashboardModel.createTool toolType

  removeTools: =>
    @dashboardModel.removeTools()

  showIndex: =>
    @appFocusView = @dashboardView
    @render()

  showSaved: =>
    @savedListView.collection = User.current.dashboards
    @appFocusView = @savedListView
    @render()
  
module.exports = AppView
