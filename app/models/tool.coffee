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
    @set 'dataSource', new DataSource({tools: @collection})
    @set 'filters', new Filters
    @set 'settings', new Settings
    @get('dataSource').on 'data-received', @bubbleEvent

  bubbleEvent: =>
    unless @get('dataSource').isExternal()
      @trigger 'bind-tool', @get('dataSource').get('source'), @
    else
      @boundTool = false

  setElements: (ids) =>
    if not @equalElements(ids)
      @set 'selectedElements', ids
      @trigger 'change'
      @trigger 'change:selectedElements'

  bindTool: (tool) =>
    @boundTool = tool
    @set({'selectedElements': @boundTool.get('selectedElements')}, {silent: true})
    @set({'selectedKey': @boundTool.get('selectedKey')}, {silent: true})
    @get('filters').add @boundTool.get('filters').models.slice()

    @boundTool.on 'change:selectedElements', @updateSelectedElements
    @boundTool.on 'change:selectedKey', @updateSelectedKey
    @boundTool.get('filters').on 'add', @updateFilters

  updateSelectedElements: =>
    @set 'selectedElements', @boundTool.get('selectedElements').slice()
    
  updateSelectedKey: =>
    @set 'selectedKey', @boundTool.get('selectedKey')

  updateFilters: (filter) =>
    @get('filters').add filter
    console.log @get 'filters'

  equalElements: (ids) =>
    oldIds = @get 'selectedElements'

    if typeof oldIds is 'undefined' or oldIds.length is 0
      test = false
    else
      test = (ids.length is _.filter(oldIds, (id) -> id in ids).length)
      test = test or ids.length < oldIds.length
    return test

module.exports = Tool
