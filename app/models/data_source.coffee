Params = require 'collections/params'

class DataSource extends Backbone.AssociatedModel
  sync: require 'sync' 
  manager: require 'modules/manager'
  subjects: require 'collections/subjects'

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
    url = @manager.get('sources').get(@get('source')).get('url')
    @data = new @subjects([], {params: @get('params'), url: url })
    @data.fetch
      success: =>
        @trigger 'change'

  fetchInt: =>
    if not _.isUndefined @get('source')
      @set 'source', @get('source')
      @data = undefined
      @trigger 'change'

  isExternal: =>
    (@get('source_type') is 'external')

  isInternal: =>
    (@get('source_type') is 'internal')

  isReady: =>
    if @data? and not @data.isEmpty()
      dataReady = true
    else
      dataReady = false

    (@isInternal() and @get('source')?) or (@isExternal() and dataReady)

  sourceName: =>
    if @isExternal()
      name = @manager.get('sources').get(@get('source')).get('name')
    else if @isInternal()
      name = @get('source')
    else
      name = ''
    return name

module.exports = DataSource