User = require 'user'

AppView = require 'app_view'

class Router extends Backbone.Router
  routes:
    ''              : 'index'
    'new'           : 'newDashboard'
    'my_dashboards' : 'savedDashboards'
    ':id'           : 'retrieveDashboard'

  initialize: ->
    @appView = new AppView({el: $('#app')})
    @appView.render()

  index: ->
    Backbone.Mediator.publish 'router:index'

  retrieveDashboard: (id) =>
    Backbone.Mediator.publish 'router:dashboardRetrieve', id
    @appView.loadDashboard(id)

  newDashboard: =>
    @navigate("", {trigger: true}) if User.current is null
    Backbone.Mediator.publish 'router:dashboardCreate'

  savedDashboards: =>
    @navigate("", {trigger: true}) if User.current is null
    Backbone.Mediator.publish 'router:viewSavedDashboards'

module.exports = Router
