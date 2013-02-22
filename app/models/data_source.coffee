Params = require 'collections/params'

class DataSource extends Backbone.AssociatedModel
  manager: require 'modules/manager'
  extSubjects: require 'collections/external_subjects'

  nonDisplayKeys: ['id', 'uid', 'image', 'thumb']

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
      url = @manager.get('sources').get(@get('source')).get('url')
      @data = new @extSubjects([], {params: @get('params'), url: url })
      @data.fetch()
    else if @isZooniverse()
      console.log 'here'
    else
      throw new Error('unknown source type')

  isExternal: =>
    (@get('source_type') is 'external')

  isZooniverse: =>
    (@get('source_type') is 'zoooniverse')

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