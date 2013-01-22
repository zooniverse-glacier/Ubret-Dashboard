AppView = require 'app_view'
Manager = require 'modules/manager'
User = require 'user'

class Router extends Backbone.Router
  routes:
    '': 'index'
    'my_dashboards': 'savedDashboards'
    'dashboards/:id': 'retrieveDashboard'
    'project/:project': 'loadProject'
    'project/:project/object/:objectId': 'loadObject'

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
    Manager.set 'project', project
    Manager.set 'object', objectId
    Backbone.Mediator.publish 'router:dashboardCreate'


module.exports = Router