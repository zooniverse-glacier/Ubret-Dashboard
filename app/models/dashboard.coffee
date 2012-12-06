Tools = require 'collections/tools'
Tool = require  'models/tool'
Sources = require 'collections/sources'
User = require 'user'
corsSync = require 'sync'

class Dashboard extends Backbone.Model
  urlRoot: '/dashboards'

  sync: corsSync

  parse: (response) ->
    response.tools = @get('tools').add tool for tool in response.tools
    delete response.tools
    @get('tools')['dashboardId'] = response.id
    @resetCount()
    response

  initialize: ->
    @set 'tools', new Tools
    @resetCount()
    @save().success => 
      User.current.updateDashboards @id, @get('name')
      Backbone.Mediator.publish 'dashboard:initialized', @

  createTool: (toolType) =>
    @get('tools').add 
      type: toolType 
      name: "#{toolType}-#{@count}" 
      channel: "#{toolType}-#{@count}"
    @count += 1

  resetCount: =>
    @count = @get('tools').length + 1

  removeTools: =>
    @get('tools').each (tool) -> tool.destroy()
    @resetCount()
    @save()

module.exports = Dashboard