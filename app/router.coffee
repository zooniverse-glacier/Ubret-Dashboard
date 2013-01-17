User = require 'user'

AppView = require 'app_view'

class Router extends Backbone.Router
  routes:
    '': 'index'
    'my_dashboards': 'savedDashboards'
    'dashboards/:id': 'retrieveDashboard'
    'project/:projectId': 'loadProject'
    'project/:projectId/object/:objectId': 'loadObject'

  initialize: ->
    @appView = new AppView({el: $('#app')})

  index: ->
    @navigate("/my_dashboards", {trigger: true}) if User.current isnt null
    Backbone.Mediator.publish 'router:index'

  retrieveDashboard: (id) =>
    $.getJSON '/tools.json', (tools) ->
      ###
      Long-form way of checking if scripts are loaded.
      Also not really the location I want to put this in the end.
      ###
      isScriptNotLoaded = (script) ->
        if _.isUndefined window[script]
          # Not on window. Maybe an Ubret script.
          if _.isUndefined Ubret[script]
            return true
        return false

      # A highly inefficient way of resolving dependencies.
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
          Backbone.Mediator.publish 'router:dashboardRetrieve', id

  savedDashboards: =>
    @navigate("", {trigger: true}) if User.current is null
    Backbone.Mediator.publish 'router:viewSavedDashboards'

  loadProject: (projectId) ->
    console.log 'lp', projectId

  loadObject: (projectId, objectId = null) ->
    console.log 'lo', projectId, objectId

module.exports = Router
