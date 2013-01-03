Tool = require 'models/tool'
corsSync = require 'sync'

class Tools extends Backbone.Collection
  model: Tool

  sync: corsSync

  url: =>
    "/dashboards/#{@dashboardId}/tools"

  focus: (tool) ->
    maxZindex = @max((tool) -> tool.get('zindex')).get('zindex')
    tool.save({ zindex: maxZindex + 1})

module.exports = Tools
