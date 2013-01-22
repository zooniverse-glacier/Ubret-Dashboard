AppView = require 'app_view'
Manager = require 'modules/manager'
Router = require 'router'
Sources = require 'collections/sources'
User = require 'user'

application =
  initialize: ->
    sources = new Sources()
    sources.fetch()

    Manager.set 'sources', sources

    User.currentUser().always =>
      router = new Router
      Manager.set 'router', router
      appView = new AppView({el: $('#app')})
      Backbone.history.start()

module.exports = application