DataSource = require 'models/data_source'
Filters = require 'collections/filters'

class Tool extends Backbone.Model
  defaults:
    "height": 480
    "width": 640
    "left": 20
    "top": 20
    "zindex": 1

  initialize: ->
    @set 'dataSource', new DataSource
    @set 'filters', new Filters
    @get('dataSource').on 'change:source', @bubbleEvent

  bubbleEvent: =>
    if not @get('dataSource').isExternal()
      @trigger 'bind-tool', @get('dataSource').get('source'), @
    else
      @boundTool = null if @boundTool

  filterData: =>
    if @boundTool
      filteredData = @boundTool.getData()
    else
      filteredData = @get('dataSource').get('data').models
    @get('filters').each (filter) =>
      filteredData = _.filter filteredData, filter.get('func')
    return filteredData

  getData: =>
    unless @get('dataSource').has('source')
      return []
    return @filterData()

  bindTool: (tool) =>
    @boundTool = tool
    @boundTool.on 'change:selectedElement', @updateSelectedElement
    @boundTool.on 'change:selectedKey', @updateSelectedKey

  updateSelectedElement: =>
    @set 'selectedElement', @boundTool.get('selectedElement')
    
  updateSelectedKey: =>
    @set 'selectedKey', @boundTool.get('selectedKey')

module.exports = Tool
