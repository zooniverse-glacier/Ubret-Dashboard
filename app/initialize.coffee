AppView = require 'app_view'
Manager = require 'modules/manager'
Router = require 'lib/router'
Sources = require 'collections/sources'
User = require 'lib/user'

$(document).on 'ready', ->
  sources = new Sources()
  Manager.set 'sources', sources
  new zooniverse.Api host: Manager.baseApi()

  User.currentUser().always =>
    router = new Router
    Manager.set 'router', router
    appView = new AppView({el: $('.app')})
    Backbone.history.start()