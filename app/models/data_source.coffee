class DataSource extends Backbone.AssociatedModel
  sync: require 'sync' 

  relations: [
    type: Backbone.Many
    key: 'params'
    relatedModel: require 'models/param'
    collectionType: require 'collections/params'
  ]

  defaults:
    params: []

  manager: require 'modules/manager'
  subjects: require 'collections/subjects'

  urlRoot: =>
    "/dashboards/#{@manager.get('dashboardId')}/tools/#{@get('toolId')}/data_sources"

  toJSON: =>
    json = super
    delete json.tools
    json

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
      @data = []
      @trigger 'change'

  isExternal: =>
    (@get('source_type') is 'external')

  isInternal: =>
    (@get('source_type') is 'internal')

  isReady: =>
    (@isInternal() and (not _.isUndefined(@get('source')))) or (@isExternal() and (not _.isUndefined(@data)))

  sourceName: =>
    if @isExternal()
      name = @manager.get('sources').get(@get('source')).get('name')
    else if @isInternal()
      name = @get('source')
    else
      name = ''
    return name

module.exports = DataSource