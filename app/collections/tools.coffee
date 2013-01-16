corsSync = require 'sync'
Tool = require 'models/tool'

class Tools extends Backbone.Collection
  model: Tool
  sync: corsSync

  url: =>
    "/dashboards/#{@dashboardId}/tools"

  focus: (tool) ->
    if @length is 0
      tool.save {zindex: 1}
      return

    maxZindexTool = @max((tool) -> tool.get('zindex'))
    unless tool.cid is maxZindexTool.cid then tool.save({zindex: maxZindexTool.get('zindex') + 1})

module.exports = Tools
