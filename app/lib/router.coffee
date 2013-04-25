User = require('lib/user')
Manager = require('modules/manager')

class Router extends Backbone.Router
  routes:
    '': 'index'
    'my_dashboards': 'savedDashboards'
    'dashboards/:project/:id': 'retrieveDashboard'
    'my_data' : 'myData'
    'project/:project': 'loadProject'
    'project/:project/:object(/:setting_keys/:setting_values)' : 'loadObject'
    'project/:project/:name/:tools/:collection/:params': 'loadObjects'
  
  initialize: ->
    User.on 'sign-in', => 
      @navigate(User.incomingLocation, {trigger: true})
    User.on 'sign-out', => @navigate("#/", {trigger: true})

  checkUser: ->
    if User.current
      true
    else
      User.incomingLocation = location.hash
      @navigate("#/", {trigger: true})
      false

  index: ->
    unless User.current?
      Backbone.Mediator.publish 'router:index'
    else
      @navigate("#/my_dashboards", {trigger: true})

  retrieveDashboard: (project, id) =>
    Manager.set('project', project)
    Backbone.Mediator.publish 'router:dashboardRetrieve', id

  myData: ->
    return unless @checkUser()
    Backbone.Mediator.publish 'router:myData'

  savedDashboards: =>
    return unless @checkUser()
    Backbone.Mediator.publish 'router:viewSavedDashboards'

  loadProject: (project) ->
    return unless @checkUser()
    Manger.set 'project', project
    @navigate('#/my_dashboards', {trigger: true})

  loadObject: (project, object, settingKeys, settingValues) =>
    return unless @checkUser()
    Manager.set 'project', project
    name = "Dashboard with #{object}"
    settings = {}
    if settingKeys?
      keys = settingKeys.split('-')
      values = settingValues.split('-')
      settings[key] = values[index] for key, index in keys
    Backbone.Mediator.publish 'router:dashboardCreateFromZooid', name, object, settings

  loadObjects: (project, name, tools, collection, params) =>
    return unless @checkUser()
    Manager.set 'project', project
    name = name.split('-')
    tools = tools.split('-')
    collection = collection.split('-')
    params = params.split('-')
    Backbone.Mediator.publish 'router:dashboardCreateFromParams', name, tools, collection, params

module.exports = Router