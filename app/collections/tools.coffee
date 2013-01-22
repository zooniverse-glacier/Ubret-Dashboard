class Tools extends Backbone.Collection
  model: require('models/tool')
  sync: require('sync') 

  initialize: -> 
    @on 'change:dataSource.source', @setDataSource

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

  loadTools: =>
    internalTools = @filter (tool) =>
      tool.get('dataSource').isInternal()

    externalTools = @filter (tool) =>
      tool.get('dataSource').isExternal()

    _(internalTools).each (tool) =>
      tool.get('dataSource').source.on('change:dataSource') =>
        tool.get('dataSource').fetchData

    _(externalTools).each (tool) =>
      tool.get('dataSource').fetchData

  setDataSource: (model) =>
    if model.get('dataSource').isInternal()
      source = @find (tool) =>
        tool.get('channel') is model.get('dataSource').get('source')
      model.get('dataSource').source = source

module.exports = Tools
