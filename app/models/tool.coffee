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

    @dataSource = new DataSource response.data_source, {silent: true}
    @filters = new Filters response.filters, {silent: true}
    @settings = new Settings response.settings, {silent: true}

    delete response.filters
    delete response.data_source
    delete response.settings

    response

  toJSON: ->
    json = new Object
    json[key] = value for key, value of @attributes
    json[key] = @[key].toJSON() for key in ['dataSource', 'filters', 'settings']
    json

  initialize: ->
    @filters = @filters or new Filters
    @settings = @settings or new Settings

    @dataSource = @dataSource or new DataSource
    @dataSource.set 'tools', @collection
    @dataSource.on 'source:dataReceived', @onDataReceived

    if typeof @id is 'undefined'
      @generatePosition()
      @focusWindow() if @collection?
      @save [], { success: => @dataSource['toolId'] = @id } 
    else
      @dataSource['toolId'] = @id

  onDataReceived: =>
    if @dataSource.isExternal()
      @boundTool = false
      @triggerEvent 'tool:dataProcessed'

    else
      @trigger 'bind-tool', @dataSource.get('source'), @

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
    y_min = doc_height * 0.10

    x = Math.random() * (x_max - x_min) + x_min
    y = Math.random() * (y_max - y_min) + y_min

    @set
      top: y
      left: x

module.exports = Tool
