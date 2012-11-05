DataSource = require 'models/data_source'
Filters = require 'collections/filters'

class Tool extends Backbone.Model
  defaults:
    "dataSource": new DataSource
    "filters": new Filters
    "height": 480
    "width": 640
    "left": 20
    "top": 20
    "z-index": 1

  filterData: =>
    filteredData = @get('dataSource').get('data').models
    @get('filters').each (filter) =>
      filteredData = _.filter filteredData, filter.get('func')
    return filteredData

  getData: =>
    unless @get('dataSource').has('source')
      return []
    return @filterData()

module.exports = Tool
