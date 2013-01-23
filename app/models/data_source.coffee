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
    "/dashboards/#{@get('tools').dashboardId}/tools/#{@get('toolId')}/data_sources"

  toJSON: ->
    json = new Object
    json[key] = value for key, value of @attributes
    json

  fetchData: =>
    # @save()
    if @isExternal()
      @fetchExt()
    else if @isInternal()
      @fetchInt()
    else
      throw 'unknown source type'

  fetchExt: =>
    url = @manager.get('sources').get(@get('source')).get('url')
    data = new @subjects([], {params: @get('params'), url: url })
    data.fetch
      success: (data) =>
        @set 'data', data

  fetchInt: =>
    if not _.isUndefined @source
      @set 'data', []

  isExternal: =>
    (@get('type') is 'external')

  isInternal: =>
    (@get('type') is 'internal')

  isReady: =>
    (@isInternal() and (not _.isUndefined(@source))) or (@isExternal() and (not _.isUndefined(@get('data'))))

  sourceName: =>
    if @isExternal()
      name = @manager.get('sources').get(@get('source')).get('name')
    else if @isInternal()
      name = @source.get('name')
    else
      name = ''
    return name

module.exports = DataSource