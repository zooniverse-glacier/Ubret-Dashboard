application = require 'application'
Table = require 'ubret/lib/controllers/Table'

$ ->
  console.log Table
  application.initialize()

  Backbone.history.start()
