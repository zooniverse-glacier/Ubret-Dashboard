Router = require 'router'
AppView = require 'views/app_view'

appView = new AppView { el: '#main' }
router = new Router { appView: appView }
Backbone.history.start()
