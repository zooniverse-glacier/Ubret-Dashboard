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
    $.getJSON '/tools.json', (tools) ->
      ###
      Long-form way of checking if scripts are loaded.
      ###
      isScriptNotLoaded = (script) ->
        if _.isUndefined window[script]
          # Not on window. Maybe an Ubret script.
          if _.isUndefined Ubret[script]
            return true
        return false

      # A probably highly in-efficient way of resolving dependencies.
      # Not recursive yet either (dependency cannot have a dependency).
      tempScripts = []
      for tool in tools.projects.default
        # Does tool have any dependencies
        if tools.scripts[tool].hasOwnProperty 'dependencies'
          # Add dependency to loading array
          for dependency in tools.scripts[tool].dependencies
            tempScripts.push
              name: dependency
              source: tools.scripts[dependency].source

        # Add script as well.
        tempScripts.push
          name: tool
          source: tools.scripts[tool].source

      uniqueScripts = _.uniq tempScripts, (script) -> script.name
      console.log 'us', uniqueScripts
      funcList = []
      for script in uniqueScripts
        do (script) ->
          funcList.push (cb) ->
            yepnope
              test: isScriptNotLoaded script
              yep: script.source
              complete: -> cb null, true

      async.parallel funcList, (err, results) ->
        if err
          console.log 'Error loading tools.', err
          return
        else
          Backbone.Mediator.publish 'tools:loaded'

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
