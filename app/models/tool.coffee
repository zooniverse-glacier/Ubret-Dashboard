AppModel = require 'models/app_model'
DataSource = require 'models/data_source'
Settings = require 'models/settings'
Filters = require 'collections/filters'
corsSync = require 'sync'

class Tool extends AppModel
  sync: corsSync

  defaults:
    "height": 480
    "width": 640

  parse: (response) =>
    if not response?
      return ''

    @get('dataSource').set(key, value, {silent: true}) for key, value of response.data_source when key isnt 'data' 
    @get('filters').add(filter, {silent: true}) for filter in response.filters
    @get('settings').set(key, value, {silent: true}) for key, value of response.settings

    delete response.filters
    delete response.data_source
    delete response.settings

    response

  initialize: ->
    @set 'dataSource', new DataSource({tools: @collection})
    @set 'filters', new Filters
    @set 'settings', new Settings
    @get('dataSource').on 'source:dataReceived', @onDataReceived
    @generatePosition()
    @focusWindow() if @collection?
    @save [], { success: => @get('dataSource')['toolId'] = @id }

  onDataReceived: =>
    if @get('dataSource').isExternal()
      @boundTool = false
      @triggerEvent 'tool:dataProcessed'
    else
      @trigger 'bind-tool', @get('dataSource').get('source'), @

  bindTool: (tool) =>
    @boundTool = tool
    @save({'selectedElements': @boundTool.get('selectedElements')}, {silent: true})
    @save({'selectedKey': @boundTool.get('selectedKey')}, {silent: true})
    # @get('filters').add @boundTool.get('filters').models.slice()

    @boundTool.on 'change:selectedElements', @updateSelectedElements
    @boundTool.on 'change:selectedKey', @updateSelectedKey
    # @boundTool.get('filters').on 'add', @updateFilters
    @triggerEvent 'tool:dataProcessed'

  # Elements, Keys, Filters
  updateSelectedElements: =>
    @save 'selectedElements', @boundTool.get('selectedElements').slice()
    
  updateSelectedKey: =>
    @save 'selectedKey', @boundTool.get('selectedKey')

  updateFilters: (filter) =>
    @get('filters').add filter
    console.log @get 'filters'

  setElements: (ids) =>
    if not @equalElements(ids)
      @save 'selectedElements', ids
      @trigger 'change'
      @trigger 'change:selectedElements'

  equalElements: (ids) =>
    oldIds = @get 'selectedElements'

    if typeof oldIds is 'undefined' or oldIds.length is 0
      test = false
    else
      test = (ids.length is _.filter(oldIds, (id) -> id in ids).length)
      test = test or ids.length < oldIds.length
    return test

  # initializers
  focusWindow: =>
    zindex = @getMaxZIndex()
    @save 'zindex', zindex + 1 unless @get('zindex') is zindex

  getMaxZIndex: =>
    if @collection.length isnt 0
      @collection.max((tool) -> tool.get('zindex')).get('zindex')
    else
      0

  generatePosition: ->
    doc_width = $(document).width()
    doc_height = $(document).height()

    x_max = doc_width * 0.6
    x_min = doc_width * 0.02

    y_max = doc_height * 0.35
    y_min = doc_height * 0.05

    x = Math.random() * (x_max - x_min) + x_min
    y = Math.random() * (y_max - y_min) + y_min

    @set
      top: y
      left: x

module.exports = Tool
