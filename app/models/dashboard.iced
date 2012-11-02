Tools = require 'collections/tools'

class Dashboard extends Backbone.Model
  defaults:
    "tools": new Tools

  urlRoot: '/dashboard'

  parse: (response) ->
    response.tools = new Tools response.tools
    response

  createTool: (toolType) =>
    @get('tools').add { type: toolType }

  removeTools: =>
    @get('tools').reset()

module.exports = Dashboard