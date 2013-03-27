Manager = require 'modules/manager'

class Tools extends Backbone.Collection
  model: require('models/tool')
  sync: require('lib/ouroboros_sync') 

  url: =>
    "/dashboards/#{Manager.get('dashboardId')}/tools"

  focus: (tool) ->
    if @length is 0
      tool.updateFunc {zindex: 1}
      return
    maxZindexTool = @max((tool) -> tool.get('zindex'))
    unless tool.cid is maxZindexTool.cid
      tool.updateFunc({zindex: maxZindexTool.get('zindex') + 1})

module.exports = Tools
