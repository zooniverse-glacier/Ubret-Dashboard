GalaxyZooSubjects = require 'collections/galaxy_zoo_subjects'

class DataSource extends Backbone.Model
  initialize: ->
    @.on 'change:source', @createNewData
    @createNewData() if (not @has('data')) and (@has('source'))

  sourceToCollection: =>
    switch @attributes['source']
      when 'Galaxy Zoo' then return GalaxyZooSubjects
      else return 'internal'

  fetchData: =>
    @attributes['data'].fetch()

  createNewData: =>
    sourceType = @sourceToCollection()
    if sourceType isnt 'internal'
      params = @attributes['params'] or {}
      dataCollection = new sourceType([], { params: params })
      console.log dataCollection
      @set 'data', dataCollection

  isExternal: =>
    @sourceToCollection() isnt 'internal'

module.exports = DataSource