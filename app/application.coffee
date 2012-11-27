Router = require 'router'
Manager = require 'modules/manager'

Sources = require 'collections/sources'

application =
  initialize: ->
    sources = new Sources()
    sources.fetch()

    Manager.save('sources', sources)

    router = new Router
    Backbone.history.start()

module.exports = application
