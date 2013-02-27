Params = require 'collections/params'

class DataSource extends Backbone.AssociatedModel
  manager: require 'modules/manager'
  extSubjects: require 'collections/external_subjects'
  zooSubjects: require 'collections/zooniverse_subjects'

  nonDisplayKeys: ['id', 'uid', 'image', 'thumb']
 
  idAttribute: "tool_id"

  initialize: (opts) ->
    params = opts.params || []
    @set 'params', new Params params

  # Server methods
  parse: (response) =>
    response.params = new Params response.params
    return response

  toJSON: =>
    json = new Object
    json[key] = value for key, value of @attributes when key isnt 'data'
    json

  # DS API
  fetchData: =>
    if @isZooniverse()
      console.log @get('search_type')
      url = @manager.get('sources')
        .get(@get('source'))
        .get('search_types')[@get('search_type')].url
      console.log url
      @data = new @zooSubjects([], 
        params: @get('params')
        search_type: @get('search_type')
        url: url)
      @data.fetch()
    else if @isExternal()
      url = @manager.get('sources').get(@get('source')).get('url')
      @data = new @extSubjects([], {params: @get('params'), url: url })
      @data.fetch()
    else
      throw new Error('unknown source type')

  isExternal: =>
    (@get('source_type') is 'external')

  isZooniverse: =>
    (@get('source') is '1')

  isInternal: =>
    (@get('source_type') is 'internal')

  dataKeys: =>
    unless @data?
      return []

    keys = new Array
    for key, value of @data.toJSON()[0]
      keys.push key unless key in @nonDisplayKeys
    return keys

module.exports = DataSource