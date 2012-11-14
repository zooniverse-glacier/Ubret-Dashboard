Tools = require 'collections/tools'

class Dashboard extends Backbone.Model
  defaults:
    "tools": new Tools

  urlRoot: '/dashboard'

  initialize: ->
    @count = @get('tools').length + 1

  parse: (response) ->
    response.tools = new Tools response.tools
    response

  createTool: (toolType) =>
    @get('tools').add 
      type: toolType 
      name: "new-#{toolType}-#{@count}" 
      channel: "#{toolType}-#{@count}"
    @count += 1

  removeTools: =>
    @get('tools').remove @get('tools').models
    @count = 0

module.exports = Dashboard