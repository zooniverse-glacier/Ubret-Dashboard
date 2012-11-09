Router = require 'router'

application =
  initialize: ->
    router = new Router
    Backbone.history.start()

module.exports = application