User = require('lib/user')
Manager = require('modules/manager')

class Router extends Backbone.Router
  routes:
    '': 'index'
    'my_dashboards': 'savedDashboards'
    'dashboards/:project/:id': 'retrieveDashboard'
    'my_data' : 'myData'
    'project/:project': 'loadProject'
    'project/:project/object/:objects(/:name)' : 'loadObjects'
    'project/:project/collection/:collection(/:name)' : 'loadCollection'
  
  initialize: ->
    User.on 'sign-in', => 
      @navigate(User.incomingLocation, {trigger: true})
    User.on 'sign-out', => @navigate("#/", {trigger: true})

  checkUser: (navigate=true) ->
    if User.current
      true
    else
      User.incomingLocation = location.hash
      @navigate("#/", {trigger: true}) if navigate
      false

  index: ->
    unless User.current?
      Backbone.Mediator.publish 'router:index'
    else
      @navigate("#/my_dashboards", {trigger: true})

  retrieveDashboard: (project, id) =>
    @checkUser(false)
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

  loadObjects: (project, objects, name) =>
    return unless @checkUser()
    Manager.set 'project', project
    name = name or "Dashboard with #{objects.slice(0,12)}"
    Backbone.Mediator.publish 'router:dashboardCreateFromZooids', name.replace('-', ' ', 'g'), objects.split(',')

  loadCollection: (project, collection, name) =>
    return unless @checkUser()
    Manager.set 'project', project
    name = name or "Dashboard from #{collection}"
    Backbone.Mediator.publish 'router:dashboardCreateFromCollection', name.replace('-', ' ', 'g'), collection

module.exports = Router