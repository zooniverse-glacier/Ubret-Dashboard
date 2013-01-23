class DataSource extends Backbone.AssociatedModel
  sync: require 'sync' 

  relations: [
    type: Backbone.Many
    key: 'params'
    relationModel: require 'models/param'
    collectionType: require 'collections/params'
  ]

  defaults:
    params: []

  manager: require 'modules/manager'
  subjects: require 'collections/subjects'

  urlRoot: =>
    console.log @
    "/dashboards/#{@get('tools').dashboardId}/tools/#{@get('toolId')}/data_sources"

  fetchData: =>
    @save()
    if @isExternal()
      @fetchExt()
    else if @isInternal()
      @fetchInt()
    else
      throw 'unknown source type'

  fetchExt: =>
    url = @manager.get('sources').get(@get('source')).get('url')
    @data = new @subjects([], {params: @params, url: url })
    @data.fetch

  fetchInt: =>
    if not _.isUndefined @source
      @data = []

  isExternal: =>
    (@get('type') is 'external')

  isInternal: =>
    (@get('type') is 'internal')

  isReady: =>
    (@isInternal() and (not _.isUndefined(@source))) or (@isExternal() and (not _.isUndefined(@data)))

  sourceName: =>
    if @isExternal()
      name = @manager.get('sources').get(@get('source')).get('name')
    else if @isInternal()
      name = @source.get('name')
    else
      name = ''
    return name

module.exports = DataSource