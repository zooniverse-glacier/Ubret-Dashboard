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

  idAttribute: "tool_id"

  # DS API
  data: =>
    if @isZooniverse()
      new @zooSubjects([], {zoo_ids: @get('params[0].val') or []})
    else if @isExternal()
      url = @manager.get('sources').get(@get('source_id')).url
      new @extSubjects([], {params: @get('params'), base: url })
    else
      throw new Error('unknown source type')

  isExternal: =>
    console.log @get('source_type')
    @get('source_type') is 'external'

  isZooniverse: =>
    @get('source_type') is 'zooniverse'

  isInternal: =>
    @get('source_type') is 'internal'

module.exports = DataSource