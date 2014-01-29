class DataSource extends Backbone.AssociatedModel
  manager: require 'modules/manager'
  extSubjects: require 'collections/external_subjects'
  zooSubjects: require 'collections/zooniverse_subjects'

  relations: [
    type: Backbone.Many
    key: 'params'
    relatedModel: require 'models/param'
    collectionType: require 'collections/params'
  ]

  defaults:
    params: []
    source_type: 'internal'

  idAttribute: "tool_id"

  # DS API
  data: =>
    if @isZooniverse()
      new @zooSubjects([], {zoo_ids: @get('params[0].val') or []})
    else if @isMpcorb()
      url = "/data/galaxy_zoo/mpcorb.json"
      new @zooSubjects([], {overrideUrl: url})
    else if @isQuench()
      url = "/data/galaxy_zoo_starburst/#{@get('search_type')}.json"
      new @zooSubjects([], {overrideUrl: url})
    else if @isExternal()
      source = @manager.get('sources').get(@get('source_id'))
      url = source.url
      builder = source.search_types[@get('search_type')].builder
      new @extSubjects([], {params: @get('params'), base: url, builder: builder })
    else
      throw new Error('unknown source type')

  isExternal: =>
    @get('source_type') is 'external'

  isZooniverse: =>
    @get('source_type') is 'zooniverse'

  isQuench: =>
    @get('source_type') is 'quench'

  isInternal: =>
    @get('source_type') is 'internal'

  isMpcorb: =>
    @get('source_type') is 'mpcorb'

module.exports = DataSource