Tools = require 'collections/tools'
Tool = require  'models/tool'
Sources = require 'collections/sources'
User = require 'user'
corsSync = require 'sync'

class Dashboard extends Backbone.Model
  urlRoot: '/dashboards'

  sync: corsSync

  parse: (response) ->
    @tools['dashboardId'] = response.id
    @tools.fetch()
    response

  initialize: ->
    @tools = new Tools
    @save().success(=> 
      User.current.updateDashboards @id, @get('name')
      Backbone.Mediator.publish 'dashboard:initialized', @) if typeof @id is 'undefined'

  createTool: (toolType) =>
    name = _.uniqueId "#{toolType}-"
    @tools.add 
      type: toolType 
      name: name
      channel: name

  toJSON: ->
    json = new Object
    json[key] = value for key, value of @attributes
    json['tools'] = tool.id for tool in @tools.toJSON if @tools.length > 0
    json

  removeTools: =>
    @tools.each (tool) -> tool.destroy()
    @resetCount()
    @save()

module.exports = Dashboard