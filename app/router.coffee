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
    'project/:project/:object(/:setting_keys/:setting_values)' : 'loadObject'
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

  loadObject: (project, object, settingKeys, settingValues) =>
    Manager.set 'project', project
    name = "Dashboard with #{object}"
    settings = {}
    if settingKeys?
      keys = settingKeys.split('-')
      values = settingValues.split('-')
      settings[key] = values[index] for key, index in keys
    Backbone.Mediator.publish 'router:dashboardCreateFromZooid', name, object, settings

  loadObjects: (project, name, tools, collection, params) =>
    Manager.set 'project', project
    name = name.split('-')
    tools = tools.split('-')
    collection = collection.split('-')
    params = params.split('-')
    Backbone.Mediator.publish 'router:dashboardCreateFromParams', name, tools, collection, params

module.exports = Router