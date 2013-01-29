Params = require 'collections/params'

class DataSource extends Backbone.AssociatedModel
  sync: require 'sync' 
  manager: require 'modules/manager'
  subjects: require 'collections/subjects'

  nonDisplayKeys: ['id', 'uid', 'image']

  initialize: (opts) ->
    params = opts.params || []
    @set 'params', new Params params

  # Server methods
  parse: (response) ->
    response.params = new Params response.params
    return response

  urlRoot: =>
    "/dashboards/#{@manager.get('dashboardId')}/tools/#{@get('tool_id')}/data_sources"

  # DS API
  fetchData: =>
    if @isExternal()
      @fetchExt()
    else if @isInternal()
      @fetchInt()
    else
      throw 'unknown source type'

  fetchExt: =>
    console.log 'fetching external data'
    url = @manager.get('sources').get(@get('source')).get('url')
    @data = new @subjects([], {params: @get('params'), url: url })
    @data.fetch
      success: =>
        console.log "fetchExt #{@get('tool_id')}:dataFetched"
        Backbone.Mediator.publish "#{@get('tool_id')}:dataFetched"

  fetchInt: =>
    console.log 'fecthing internal data'
    if @get('source')?
      @set 'source', @get('source')
      @data = undefined
      console.log "fetchInt #{@get('tool_id')}:dataFetched"
      Backbone.Mediator.publish "#{@get('tool_id')}:dataFetched"

  isExternal: =>
    (@get('source_type') is 'external')

  isInternal: =>
    (@get('source_type') is 'internal')

  isReady: =>
    # console.log 'checking data', @data?, @data
    if @data? and not @data.isEmpty()
      dataReady = true
    else
      dataReady = false

    (@isInternal() and @get('source')?) or (@isExternal() and dataReady)

  dataKeys: =>
    unless @data?
      return []

    keys = new Array
    for key, value of @data.toJSON()[0]
      keys.push key unless key in @nonDisplayKeys
    return keys

  sourceName: =>
    if @isExternal()
      name = @manager.get('sources').get(@get('source')).get('name')
    else if @isInternal()
      name = @get('source')
    else
      name = ''
    return name

module.exports = DataSource