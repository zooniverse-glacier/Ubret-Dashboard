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
    @appView.showIndex()

  retrieveDashboard: (id) =>
    @appView.createDashboard(id)

  newDashboard: =>
    @navigate("", {trigger: true}) if User.current is null
    @appView.createDashboard()

  savedDashboards: =>
    console.log 'wot'
    @navigate("", {trigger: true}) if User.current is null
    @appView.showSaved()

module.exports = Router
