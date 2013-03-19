class Tool extends Backbone.AssociatedModel
  sync: require 'lib/ouroboros_sync' 
  manager: require 'modules/manager'
  config: require 'config/tool_config'

  updateFunc:(args...) =>
    if @id?
      @save(args...)
    else
      @set(args...)

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
      @get('settings').set @config[@get("tool_type")].defaults
      @collection.focus @, false
      @on 'sync', =>
        @get('data_source').set 'tool_id', @id
    else
      @get('data_source').set 'tool_id', @id

  createUbretTool: =>
    @tool = new Ubret[@get('tool_type')]
      selector: (@get('tool_type') + "-" + @cid)
      height: parseInt(@get('height') - 25)
      width: parseInt(@get('width'))

    @tool.on 
      'selection': @selectElements
      'settings': @assignSetting

    @on 
      'change:height' : => @tool.height(parseInt(@get('height')) - 25)
      'change:width' : => @tool.width(parseInt(@get('width')))
    @trigger 'ubret-created', @tool

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

    @updateFunc
      top: y
      left: x

  setupUbretTool: =>
    if @get('data_source').isInternal()
      if @sourceTool().tool?
        @tool.parentTool(@sourceTool().tool) 
      else
        @sourceTool().once 'ubret-created', (tool) =>
          @tool.parentTool tool
    else if @get('data_source').isExternal()
      @tool.removeParentTool()
      data = @get('data_source').data()
      data.fetch().done =>
        @tool.data(data.toJSON())

    @tool.selectIds(@get('selected_uids'))
      .settings(@get('settings').toJSON())

  sourceTool: =>
    if @get('data_source').isInternal()
      @collection.get(@get('data_source').get('source'))
    else
      false

  destroy: =>
    children = @collection.filter (tool) =>
      @id is tool.get('data_source').get('source') and 
        tool.get('data_source').isInternal()
    child.destroy() for child in children
    super

  sourceName: =>
    if @get('data_source').isExternal()
      name = @manager.get('sources').get(@get('data_source').get('source')).get('name')
    else if @get('data_source').isInternal()
      name = @sourceTool()?.get('name')
    else
      name = ''
    return name

  selectElements: (ids) =>
    if _.difference(ids, @get('selected_uids')).length
      @updateFunc 'selected_uids', ids

  assignSetting: (setting) =>
    @get('settings').set setting, {silent: true}
    @updateFunc() if @get('settings').hasChanged()

module.exports = Tool