User = require 'user'

AppView = require 'app_view'

class Router extends Backbone.Router
  routes:
    ''              : 'index'
    'dashboard/new' : 'newDashboard'
    'dashboard/:id' : 'retrieveDashboard'

  initialize: ->
    @appView = new AppView({el: $('#app')})

  index: =>
    $('.dashboard').html require('views/templates/index')()

  retrieveDashboard: (id) =>
    $('.dashboard').empty()
    @navigate("", {trigger: true}) if User.current is null
    @appView.createDashboard(id)

  newDashboard: =>
    $('.dashboard').empty()
    @navigate("", {trigger: true}) if User.current is null
    @appView.createDashboard()


module.exports = Router
