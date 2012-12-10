Tool = require 'models/tool'
corsSync = require 'sync'

class Tools extends Backbone.Collection
  model: Tool

  sync: corsSync

  url: =>
    "/dashboards/#{@dashboardId}/tools"

  initialize: ->
    @.on 'bind-tool', @bindTool

  bindTool: (outTool, inTool) ->
    outToolModel = @find (tool) ->
      tool.channel is outToolModel
    inTool.bindTool outToolModel

module.exports = Tools
