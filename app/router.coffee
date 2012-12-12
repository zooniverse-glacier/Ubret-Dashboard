User = require 'user'

AppView = require 'app_view'

class Router extends Backbone.Router
  routes:
    ''              : 'index'
    'dashboard/new' : 'newDashboard'
    'dashboard/:id' : 'retrieveDashboard'
    'my_dashboards' : 'savedDashboards'

  initialize: ->
    @appView = new AppView({el: $('#app')})
    @appView.render()

  index: ->
    Backbone.Mediator.publish 'router:index'

  retrieveDashboard: (id) =>
    Backbone.Mediator.publish 'router:dashboardRetrieve', id

  newDashboard: =>
    @navigate("", {trigger: true}) if User.current is null
    Backbone.Mediator.publish 'router:dashboardCreate'

  savedDashboards: =>
    @navigate("", {trigger: true}) if User.current is null
    Backbone.Mediator.publish 'router:viewSavedDashboards'

module.exports = Router
