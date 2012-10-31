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

module.exports = Tool
