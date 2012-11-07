Tool = require 'models/tool'

class Tools extends Backbone.Collection
  model: Tool

  initialize: ->
    @.on 'bind-tool', @bindTool

  bindTool: (outTool, inTool) ->
    console.log 'here bind'
    outToolModel = @find (tool) ->
      tool.channel is outToolModel
    console.log outToolModel
    inTool.bindTool outToolModel

module.exports = Tools
