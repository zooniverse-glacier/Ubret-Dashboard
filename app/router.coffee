User = require 'user'
Manager = require 'modules/manager'
AppView = require 'app_view'

class Router extends Backbone.Router
  routes:
    '': 'index'
    'my_dashboards': 'savedDashboards'
    'dashboards/:id': 'retrieveDashboard'
    'project/:project': 'loadProject'
    'project/:project/object/:objectId': 'loadObject'

  initialize: ->
    @appView = new AppView({el: $('#app')})

  index: ->
    @navigate("#/my_dashboards", {trigger: true}) if User.current isnt null
    Backbone.Mediator.publish 'router:index'

  retrieveDashboard: (id) =>
    Backbone.Mediator.publish 'router:dashboardRetrieve', id

  savedDashboards: =>
    @navigate('', {trigger: true}) if User.current is null
    Backbone.Mediator.publish 'router:viewSavedDashboards'

  loadProject: (project) ->
    Manager.set 'project', project
    @navigate '', {trigger: true, replace: true}

  loadObject: (project, objectId = null) =>
    console.log 'lo', project, objectId
    Manager.set 'project', project
    $.ajax
      type: 'GET'
      url: "https://dev.zooniverse.org/projects/#{project}/subjects/#{objectId}"
      dataType: 'json'
      error: (xhr, status, error) ->
        console.log 'error', error
      success: (data) =>
        # So this is an interesting thing. We need to create a dashboard with a preset
        # flight of tools using the above object held in data.
        Manager.set 'object', data
        console.log 'success', data
        dashboard = @appView.createDashboard()
        dashboard.once 'change', ->
          console.log 'HELLO'
          tools = dashboard.createTool 'Statistics'
          tools = dashboard.createTool 'SubjectViewer'




module.exports = Router