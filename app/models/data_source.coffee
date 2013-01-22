class DataSource extends Backbone.AssociatedModel
  sync: require 'sync' 

  relations: [
    type: Backbone.Many
    key: 'params'
    relationModel: require 'models/param'
    collectionType: require 'collections/params'
  ]

  manager: require('modules/manager')
  subjects: require('collections/subjects')

  urlRoot: =>
    "/dashboards/#{@tools.dashboardId}/tools/#{@toolId}/data_sources"

  toJSON: ->
    json = new Object
    json[key] = value for key, value of @attributes
    json

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
      name = Manager.get('sources').get(@get('source')).get('name')
    else if @isInternal()
      name = @tools.find((tool) => tool.get('channel') == @get('source')).get('name') 
    else
      name = ''
    return name

  dataExtents: (key, ids) =>
    selectedModels = _.map((@data.filter (item) ->
      item.id in ids), (model) -> model.toJSON())
    selectedValues = _.pluck(selectedModels, key)
    selectedValues.sort()
    {min: _.first(selectedValues), max: _.last(selectedValues)}

module.exports = DataSource