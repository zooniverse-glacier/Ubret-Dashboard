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
    @dashboardView = new DashboardView
    @toolbox = new Toolbox
    @savedList = new SavedList

    @toolbox.on 'create', @addTool
    @toolbox.on 'remove-tools', @removeTools

  render: =>
    @$el.html @template()
    @assign
      '.app-header': @appHeader
      '.toolbox': @toolbox
      '.dashboard': @dashboardView
      '.saved': @savedList
    @

  createDashboard: (id) =>
    if typeof id is 'undefined'
      @dashboardModel = new DashboardModel
      @createDashboardView()
    else
      @dashboardModel = new DashboardModel { id: id }
      fetcher = @dashboardModel.fetch()
      fetcher.success @createDashboardView

  createDashboardView: =>
    @dashboardView.model = @dashboardModel
    @savedList.$el.hide()
    @dashboardView.render().$el.show()

  addTool: (toolType) =>
    @dashboardModel.createTool toolType

  removeTools: =>
    @dashboardModel.removeTools()

  showIndex: =>
    console.log 'index'

  showSaved: =>
    console.log User.current.dashboards
    @savedList.collection = User.current.dashboards
    @savedList.render().$el.show()
    @dashboardView.$el.hide()
  
module.exports = AppView
