AppView = require 'app_view'
Manager = require 'modules/manager'
User = require 'user'

class Router extends Backbone.Router
  routes:
    '': 'index'
    'my_dashboards': 'savedDashboards'
    'dashboards/:id': 'retrieveDashboard'
    'dashboards/:dash_id/tools/:tool_id' : 'showTool'
    'my_data' : 'myData'
    'project/:project': 'loadProject'
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

  loadObjects: (project, name, tools, collection, params) =>
    Manager.set 'project', project
    name = name.split('-')
    tools = tools.split('-')
    collection = collection.split('-')
    params = params.split('-')
    Backbone.Mediator.publish 'router:dashboardCreateFromParams', name, tools, collection, params

  showTool: (dash_id, tool_id) ->
    Backbone.Mediator.publish 'router:showTool', dash_id, tool_id

module.exports = Router