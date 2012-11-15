Tools = require 'collections/tools'

class Dashboard extends Backbone.Model
  defaults:
    "tools": new Tools

  urlRoot: '/dashboard'

  initialize: ->
    @resetCount()

  parse: (response) ->
    response.tools = new Tools response.tools
    response

  createTool: (toolType) =>
    @get('tools').add 
      type: toolType 
      name: "new-#{toolType}-#{@count}" 
      channel: "#{toolType}-#{@count}"
    @count += 1

  resetCount: =>
    @count = @get('tools').length + 1

  removeTools: =>
    @get('tools').remove @get('tools').models
    @resetCount()

module.exports = Dashboard