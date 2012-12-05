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

    User.currentUser()
    # topBar = new TopBar {el: '.zooniverse-top-bar'}
    # topBar.render()

    router = new Router
    Backbone.history.start()

module.exports = application
