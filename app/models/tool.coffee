corsSync = require 'sync'
BaseModel = require 'models/base_model'
DataSource = require 'models/data_source'
Settings = require 'models/settings'

class Tool extends BaseModel
  sync: corsSync

  defaults:
    "height": 480
    "width": 640
    "active": true

  initialize: ->
    unless @get('name') then @set 'name', "#{@get('type')}-#{@collection.length + 1}"
    unless @get('channel') then @set 'channel', "#{@get('type')}-#{@collection.length + 1}"
    unless @get('zindex') then @collection.focus @, false

    # @filters = @filters or new Filters
    @settings = @settings or new Settings

    @dataSource = @dataSource or new DataSource
    @dataSource.tools = @collection
    @dataSource.on 'source:dataReceived', @onDataReceived

    @settings.on 'change', => @save() unless typeof @id is null

    if typeof @id is 'undefined'
      @generatePosition()
      @save [],
        silent: true
        success: =>
          @dataSource['toolId'] = @id
    else
      @dataSource['toolId'] = @id

  parse: (response) =>
    unless response? then return ''

    if @dataSource
      @dataSource.set response.data_source, {silent: true}
    else
      @dataSource = new DataSource response.data_source
      @dataSource.tools = @collection

    if @settings
      @settings.set response.settings, {silent: true}
    else
      @settings = new Settings response.settings

    delete response.data_source
    delete response.settings

    response

  toJSON: ->
    json = new Object
    json[key] = value for key, value of @attributes
    json[key] = @[key].toJSON() for key in ['dataSource', 'settings']
    json

  onDataReceived: =>
    console.log 'tool:dataProcessed'
    @triggerEvent 'tool:dataProcessed'

  # Elements, Keys, Filters
  updateSelectedElements: =>
    @save 'selectedElements', @boundTool.get('selectedElements').slice()
    
  updateSelectedKey: =>
    @save 'selectedKey', @boundTool.get('selectedKey')

  updateFilters: (filter) =>
    @get('filters').add filter

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

  generatePosition: ->
    doc_width = $(document).width()
    doc_height = $(document).height()
    toolbox_bot = $('.toolbox').offset().top + $('.toolbox').height() + 20

    x_max = doc_width * 0.6
    x_min = doc_width * 0.02

    y_max = doc_height * 0.35
    if doc_height * 0.10 < toolbox_bot
      y_min = toolbox_bot
    else
      y_min = doc_height * 0.10

    x = Math.random() * (x_max - x_min) + x_min
    y = Math.random() * (y_max - y_min) + y_min

    @set
      top: y
      left: x


module.exports = Tool