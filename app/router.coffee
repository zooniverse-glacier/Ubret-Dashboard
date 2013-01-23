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
    if User.current is null
      @navigate('', {trigger: true})
    else
      Backbone.Mediator.publish 'router:viewSavedDashboards'

  loadProject: (project) ->
    Manager.set 'project', project
    Backbone.Mediator.publish 'router:dashboardCreate'

  loadObject: (project, objectId = null) =>
    Manager.set 'project', project
    Manager.set 'object', objectId
    Backbone.Mediator.publish 'router:dashboardCreate'


module.exports = Router