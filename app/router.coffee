User = require 'user'
Manager = require 'modules/manager'
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
    console.log 'loading dashbooard', id
    Backbone.Mediator.publish 'router:dashboardRetrieve', id

  savedDashboards: =>
    @navigate("", {trigger: true}) if User.current is null
    Backbone.Mediator.publish 'router:viewSavedDashboards'

  loadProject: (projectId) ->
    Manager.save 'project', projectId
    @navigate '', {trigger: true, replace: true}

  loadObject: (projectId, objectId = null) ->
    console.log 'lo', projectId, objectId

module.exports = Router
