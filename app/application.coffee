Router = require 'router'
Manager = require 'modules/manager'

TopBar = require 'views/top_bar'

Sources = require 'collections/sources'

application =
  initialize: ->
    sources = new Sources()
    sources.fetch()

    Manager.save('sources', sources)

    topBar = new TopBar {el: '.zooniverse-top-bar'}
    topBar.render()

    router = new Router
    Backbone.history.start()

module.exports = application
