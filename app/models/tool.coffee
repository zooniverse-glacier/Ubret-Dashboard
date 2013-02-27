class Tool extends Backbone.AssociatedModel
  sync: require 'lib/ouroboros_sync' 
  manager: require 'modules/manager'

  relations: [
    type: Backbone.One
    key: 'data_source'
    relatedModel: require 'models/data_source'
  ,
    type: Backbone.One
    key: 'settings'
    relatedModel: require 'models/settings'
  ]

  defaults:
    data_source: {}
    height: 480
    settings: {}
    settings_active: true
    width: 640

  initialize: ->
    unless @get('name') then @set 'name', "#{@get('tool_type')}-#{@collection.length + 1}"

    if @isNew()
      @generatePosition()
      @collection.focus @, false
      @on 'sync', =>
        @get('data_source').set 'tool_id', @id
    else
      @get('data_source').set 'tool_id', @id

  fetchData: =>
    if @get('data_source').isExternal()
      @get('data_source').fetchData().done => @trigger 'render'
    else
      @sourceTool().on 'destroy', => @destroy()
      @trigger 'render'

  generatePosition: ->
    doc_width = $(document).width()
    doc_height = $(document).height()
    toolbox_bot = 168 # tool box height

    x_max = doc_width * 0.3
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

  isReady: =>
    if @get('data_source').isExternal()
      @get('data_source').data? and not @get('data_source').data.isEmpty()
    else
      return false unless @get('data_source').get('source')?
      source = @sourceTool()
      if source? then source.isReady() else false

  sourceTool: =>
    @collection.get(@get('data_source').get('source'))

  sourceName: =>
    if @get('data_source').isExternal()
      name = @manager.get('sources').get(@get('data_source').get('source')).get('name')
    else if @get('data_source').isInternal()
      name = @sourceTool()?.get('name')
    else
      name = ''
    return name

module.exports = Tool