AppView = require 'app_view'
Manager = require 'modules/manager'
User = require 'user'

class Router extends Backbone.Router
  routes:
    '': 'index'
    'my_dashboards': 'savedDashboards'
    'dashboards/:id': 'retrieveDashboard'
    'my_data' : 'myData'
    'project/:project': 'loadProject'
    'project/:project/:object(/:setting_key/:setting_value)' : 'loadObject'
    'project/:project/:name/:tools/:collection/:params': 'loadObjects'

  index: ->
    if User.current?
      @navigate("#/my_dashboards", {trigger: true})
    else
      Backbone.Mediator.publish 'router:index'

  retrieveDashboard: (id) =>
    Backbone.Mediator.publish 'router:dashboardRetrieve', id

  myData: ->
    Backbone.Mediator.publish 'router:myData'

  savedDashboards: =>
    if User.current is null
      @navigate('', {trigger: true})
    else
      Backbone.Mediator.publish 'router:viewSavedDashboards'

  loadProject: (project) ->
    Manager.set 'project', project
    Backbone.Mediator.publish 'router:dashboardCreate'

  loadObject: (project, object, settingKey, settingValue) =>
    Manager.set 'project', project
    name = "Dashboard with #{object}"
    Backbone.Mediator.publish 'router:dashboardCreateFromZooid', name, object

  loadObjects: (project, name, tools, collection, params) =>
    Manager.set 'project', project
    name = name.split('-')
    tools = tools.split('-')
    collection = collection.split('-')
    params = params.split('-')
    Backbone.Mediator.publish 'router:dashboardCreateFromParams', name, tools, collection, params

module.exports = Router