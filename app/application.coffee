Router = require 'router'
User = require 'user'

Manager = require 'modules/manager'
# TopBar = require 'views/top_bar'

Sources = require 'collections/sources'

application =
  initialize: ->
    sources = new Sources()
    sources.fetch()

    Manager.save('sources', sources)

    User.currentUser().always ->
      User.current.on 'loaded-dashboards', ->
        router = new Router
        Backbone.history.start()

module.exports = application
