corsSync = require 'sync'
Manager = require 'modules/manager'
Sources = require 'collections/sources'
Tools = require 'collections/tools'
Tool = require  'models/tool'
User = require 'user'

class Dashboard extends Backbone.Model
  sync: corsSync
  urlRoot: '/dashboards'

  initialize: ->
    @set 'project', Manager.get 'project'
    @tools = new Tools
    if typeof @id is 'undefined'
      @save
        success: =>
          User.current.updateDashboards @id, @get('name')
          Backbone.Mediator.publish 'dashboard:initialized', @

  parse: (response) =>
    @tools['dashboardId'] = response.id
    @tools.fetch
      success: => @loadInternalTools()
    response

  createTool: (toolType) =>
    @tools.add 
      type: toolType

  toJSON: ->
    json = new Object
    json[key] = value for key, value of @attributes
    json['tools'] = tool.id for tool in @tools.toJSON if @tools.length > 0
    json

  loadInternalTools: =>
    @tools.map (tool) =>
      if tool.dataSource.get('type') is 'internal'
        source = @tools.find (sourceTool) =>
          sourceTool.get('channel') is tool.dataSource.get('source')
        source.dataSource.on 'source:dataReceived', =>
          tool.dataSource.fetchData()
    @tools.map (tool) => 
      tool.dataSource.fetchData() if tool.dataSource.get('type') is 'external'


module.exports = Dashboard