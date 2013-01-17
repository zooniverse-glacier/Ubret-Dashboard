corsSync = require 'sync'
Tool = require 'models/tool'

class Tools extends Backbone.Collection
  model: Tool
  sync: corsSync

  url: =>
    "/dashboards/#{@dashboardId}/tools"

  focus: (tool, save = true) ->
    # Temp hack
    tool.func = if save then tool.save else tool.set
    if @length is 0
      tool.func {zindex: 1}
      return
    maxZindexTool = @max((tool) -> tool.get('zindex'))
    unless tool.cid is maxZindexTool.cid then tool.func({zindex: maxZindexTool.get('zindex') + 1})

module.exports = Tools
