Tools = require 'collections/tools'
Tool = require  'models/tool'
Sources = require 'collections/sources'
corsSync = require 'sync'

class Dashboard extends Backbone.Model
  urlRoot: '/dashboards'

  sync: corsSync

  parse: (response) ->
    response.tools = @get('tools').add tool for tool in response.tools
    delete response.tools
    @get('tools')['dashboard_id'] = response.id
    @resetCount()
    response

  initialize: ->
    @set 'tools', new Tools
    @resetCount()
    @save()

  createTool: (toolType) =>
    @get('tools').add 
      type: toolType 
      name: "new-#{toolType}-#{@count}" 
      channel: "#{toolType}-#{@count}"
    @count += 1

  resetCount: =>
    @count = @get('tools').length + 1

  removeTools: =>
    @get('tools').each (tool) -> tool.destroy()
    @resetCount()
    @save()

module.exports = Dashboard