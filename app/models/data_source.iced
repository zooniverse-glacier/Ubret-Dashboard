GalaxyZooSubjects = require 'collections/galaxy_zoo_subjects'

class DataSource extends Backbone.Model
  initialize: ->
    if (not @has('data')) and (@has('source'))
      sourceType = @sourceToCollection()
      params = @attributes['params'] or {}
      dataCollection = new sourceType({ params: params })
      @set 'data', dataCollection

  sourceToCollection: =>
    switch @attributes['source']
      when 'Galaxy Zoo' then return GalaxyZooSubjects

  fetchData: =>
    @attributes['data'].fetch()

module.exports = DataSource