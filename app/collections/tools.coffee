Manager = require 'modules/manager'

class Tools extends Backbone.Collection
  model: require('models/tool')
  sync: require('sync') 

  url: =>
    "/dashboards/#{Manager.get('dashboardId')}/tools"

  focus: (tool, save = true) ->
    # Temp hack
    tool.func = if save then tool.save else tool.set
    if @length is 0
      tool.func {zindex: 1}
      return
    maxZindexTool = @max((tool) -> tool.get('zindex'))
    unless tool.cid is maxZindexTool.cid then tool.func({zindex: maxZindexTool.get('zindex') + 1})

  loadTools: ->
    internalTools = @filter (tool) ->
      tool.get('data_source').isInternal() and tool.get('data_source').isReady()

    externalTools = @filter (tool) ->
      tool.get('data_source').isExternal()

    _(internalTools).each (tool) =>
      source = @find (collection_tool) ->
        collection_tool.get('channel') is tool.get('data_source').get('source')
        
      source.once 'started', ->
        tool.get('data_source').fetchData()

    _(externalTools).each (tool) ->
      tool.get('data_source').fetchData()

  setDataSource: (dataSource) ->
    if dataSource.isInternal()
      source = @find (tool) ->
        tool.get('channel') is dataSource.get('source')
      dataSource.set 'source', source

module.exports = Tools
