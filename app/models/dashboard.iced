Tools = require 'collections/tools'

class Dashboard extends Backbone.Model
  defaults:
    "tools": new Tools

  urlRoot: '/dashboard'

  parse: (response) ->
    response.tools = new Tools response.tools
    response

module.exports = Dashboard