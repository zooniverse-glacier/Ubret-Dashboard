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
    'dashboard:fork' : 'forkDashboard'
    'router:dashboardCreate': 'createDashboard'
    'router:dashboardRetrieve': 'loadDashboard'
    'router:viewSavedDashboards': 'showSaved'
    'router:index': 'createDashboardView'

  initialize: ->
    @$el.html @template()

    @appHeader = new AppHeader({el: @$('.app-header')})
    @dashboardView = new DashboardView

    # Main area views. Switched out when appropriate.
    @appFocusView = @dashboardView

  render: =>
    @assign
      '.app-header': @appHeader
      '.main-focus': @appFocusView
    @

  forkDashboard: =>
    @dashboardModel.fork().done (response) =>
      @dashboardModel = new DashboardModel response
      ToolLoader @dashboardModel, @createDashboardView

  createDashboard: =>
    @dashboardModel = new DashboardModel
    @dashboardModel.save().done =>
      ToolLoader @dashboardModel, @createDashboardView
    return @dashboardModel

  loadDashboard: (id) =>
    @dashboardModel = new DashboardModel {id: id}
    @dashboardModel.fetch
      success: => ToolLoader @dashboardModel, @createDashboardView

  createDashboardView: =>
    @appFocusView = @dashboardView
    @render()

    Manager.get('router').navigate "#/dashboards/#{@dashboardModel.id}", {trigger: false}
    @dashboardModel.get('tools').loadTools()
    Backbone.Mediator.publish 'dashboard:initialized', @dashboardModel

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
    unless @savedListView? then @savedListView = new SavedList

    User.current.once 'loaded-dashboards', =>
      @savedListView.collection = User.current.dashboards
      @appFocusView = @savedListView
      @render()

    User.current.syncToSpelunker()


  
module.exports = AppView
