AppHeader = require 'views/app_header'
BaseView = require 'views/base_view'
DashboardModel = require 'models/dashboard'
DashboardView = require 'views/dashboard'
Manager = require 'modules/manager'
SavedList = require 'views/saved_list'
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

  createDashboard: =>
    @dashboardModel = new DashboardModel
    @dashboardModel.on 'change', =>
      window.location.hash = "/dashboards/#{@dashboardModel.id}"
      @createDashboardView()

  loadDashboard: (id) =>
    @dashboardModel = new DashboardModel {id: id}
    @dashboardModel.fetch
      success: =>
        $.getJSON '/tools.json', (tools) =>
          ###
          Long-form way of checking if scripts are loaded.
          Also not really the location I want to put this in the end.
          ###
          isScriptNotLoaded = (script) ->
            if _.isUndefined window[script.name]
              # Not on window. Maybe an Ubret script.
              if _.isUndefined Ubret[script.name]
                return true
            return false

          project = @dashboardModel.get('project')
          unless project and tools.projects.hasOwnProperty project
            project = 'default'

          # Set current project.
          Manager.set 'project', project
          
          # Set valid tools for later retrieval.
          Manager.set 'tools', tools.projects[project]

          # A highly inefficient way of resolving dependencies.
          # Not recursive yet either (dependency cannot have a dependency).
          tempScripts = []
          for tool in tools.projects[project]
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
          funcList = []
          for script in uniqueScripts
            do (script) ->
              funcList.push (cb) ->
                yepnope
                  test: isScriptNotLoaded script
                  yep: script.source
                  complete: -> cb null, true

          async.parallel funcList, (err, results) =>
            if err
              console.log 'Error loading tools.', err
              return
            else
              @createDashboardView()
              Backbone.Mediator.publish 'tools:loaded'
              Backbone.Mediator.publish 'dashboard:initialized', @dashboardModel

  createDashboardView: =>
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
