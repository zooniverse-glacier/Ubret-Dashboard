DataSource = require 'models/data_source'
Filters = require 'collections/filters'
Settings = require 'models/settings'

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
    @set 'settings', new Settings
    @get('dataSource').on 'change:source', @bubbleEvent

  bubbleEvent: =>
    if not @get('dataSource').isExternal()
      @trigger 'bind-tool', @get('dataSource').get('source'), @
    else
      @boundTool = null if @boundTool

  getData: =>
    if @boundTool
      return @boundTool.getData()
    else if @get('dataSource').has('source')
      return @get('dataSource').get('data').models
    return []

  bindTool: (tool) =>
    @boundTool = tool
    @boundTool.on 'change:selectedElement', @updateSelectedElement
    @boundTool.on 'change:selectedKey', @updateSelectedKey

  updateSelectedElement: =>
    @set 'selectedElement', @boundTool.get('selectedElement')
    
  updateSelectedKey: =>
    @set 'selectedKey', @boundTool.get('selectedKey')

module.exports = Tool
