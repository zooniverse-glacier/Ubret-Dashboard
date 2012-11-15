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
    unless @get('dataSource').isExternal()
      @trigger 'bind-tool', @get('dataSource').get('source'), @
    else
      @boundTool = null if @boundTool

  getData: =>
    if @boundTool
      return @boundTool.getData()
    else if @get('dataSource').has('source')
      return @get('dataSource').get('data').models
    return []

  setElements: (ids) =>
    if not @equalElements(ids)
      @set 'selectedElements', ids
      @trigger 'change'
      @trigger 'change:selectedElements'

  bindTool: (tool) =>
    @boundTool = tool
    @set 'selectedElements', @boundTool.get('selectedElements')
    @set 'selectedKey', @boundTool.get('selectedKey')
    @boundTool.on 'change:selectedElements', @updateSelectedElements
    @boundTool.on 'change:selectedKey', @updateSelectedKey

  updateSelectedElements: =>
    @set 'selectedElements', @boundTool.get('selectedElements')
    
  updateSelectedKey: =>
    @set 'selectedKey', @boundTool.get('selectedKey')

  equalElements: (ids) =>
    oldIds = @get 'selectedElements'

    if typeof oldIds is 'undefined' or oldIds.length is 0
      test = false
    else
      test = (ids.length is _.filter(oldIds, (id) -> id in ids).length)
      test = test or ids.length < oldIds.length
    return test

module.exports = Tool
