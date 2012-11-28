Tools = require 'collections/tools'
Tool = require  'models/tool'
Sources = require 'collections/sources'
corsSync = require 'sync'

class Dashboard extends Backbone.Model
  urlRoot: '/dashboards'

  sync: corsSync

  initialize: ->
    unless @id
      @set 'tools', new Tools
    else
      @get('tools').fetch()
    @resetCount()
    @save()

  parse: (response) ->
    tools = new Array
    tools.push new Tool {id: id} for id in response.tools
    response.tools = new Tools tools
    response

  createTool: (toolType) =>
    @get('tools').add 
      type: toolType 
      name: "new-#{toolType}-#{@count}" 
      channel: "#{toolType}-#{@count}"
    @count += 1
    @save()

  toJSON: ->
    tools = @get 'tools'
    {tools: tools.map (tool) -> tool.id}

  resetCount: =>
    @count = @get('tools').length + 1

  removeTools: =>
    @get('tools').remove @get('tools').models
    @resetCount()
    @save()

module.exports = Dashboard