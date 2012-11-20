GalaxyZooSubjects = require 'collections/galaxy_zoo_subjects'
SimbadSubjects = require 'collections/simbad_subjects'

class DataSource extends Backbone.Model
  defaults:
    data: []

  initialize: ->
    @.on 'change:source', @createNewData

  sourceToCollection: =>
    switch @attributes['source']
      when 'Galaxy Zoo' then return GalaxyZooSubjects
      when 'Simbad' then return SimbadSubjects
      else return 'internal'

  fetchData: =>
    if @isExternal()
      @attributes['data'].fetch
        success: (collection, res, opts) =>
          @onSetData()
    else
      source = @get('tools').find (tool) =>
        tool.get('channel') == @get('source')
      @set('data', source.get('dataSource').get('data'))
      @onSetData()

  onSetData: =>
    Backbone.Mediator.publish('data-received')

  createNewData: =>
    sourceType = @sourceToCollection()
    if sourceType isnt 'internal'
      params = @attributes['params'] or {}
      dataCollection = new sourceType([], { params: params })
      @set 'data', dataCollection
      @get('data')?.on 'reset', =>
        @trigger 'new-data'

  isExternal: =>
    @sourceToCollection() isnt 'internal'

  dataExtents: (key, ids) =>
    selectedModels = _.map((@get('data').filter (item) ->
      item.id in ids), (model) -> model.toJSON())
    selectedValues = _.pluck(selectedModels, key)
    selectedValues.sort()
    {min: _.first(selectedValues), max: _.last(selectedValues)}

module.exports = DataSource