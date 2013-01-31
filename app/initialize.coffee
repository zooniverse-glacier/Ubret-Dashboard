AppView = require 'app_view'
ToolView = require 'tool_view'
Manager = require 'modules/manager'
Router = require 'router'
Sources = require 'collections/sources'
User = require 'user'

$(document).on 'ready', ->
  sources = new Sources()
  sources.fetch()

  Manager.set 'sources', sources

  User.currentUser().always =>
    router = new Router
    Manager.set 'router', router
    if location.hash.split('/')[3] is 'tools'
      toolView = new ToolView({el: $('#app')})
    else
      appView = new AppView({el: $('#app')})
    Backbone.history.start()