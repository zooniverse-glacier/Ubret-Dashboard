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

  focus: (tool) ->
    maxZindex = @max((tool) -> tool.get('zindex')).get('zindex')
    tool.save({ zindex: maxZindex + 1})

module.exports = Tools
