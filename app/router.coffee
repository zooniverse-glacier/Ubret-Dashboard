AppView = require 'app_view'

class Router extends Backbone.Router
  routes:
    ''              : 'index'
    'dashboard/new' : 'newDashboard'
    'dashboard/:id' : 'retrieveDashboard'

  initialize: ->
    @appView = new AppView

  index: =>
    $('.dashboard').html require('views/templates/index')()

  retrieveDashboard: (id) =>
    @appView.createDashboard(id)

  newDashboard: =>
    @appView.createDashboard()


module.exports = Router
