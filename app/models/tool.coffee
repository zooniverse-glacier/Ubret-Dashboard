class Tool extends Backbone.AssociatedModel
  sync: require 'lib/ouroboros_sync' 
  manager: require 'modules/manager'
  config: require 'config/tool_config'
  user: require 'lib/user'

  idAttribute: '_id'

  updateFunc:(args...) =>
    if @id? and @user.current?
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
  ,
    type: Backbone.Many
    key: 'fql_statements'
    relatedModel: require 'models/fql_statement'
    collectionType: require 'collections/fql_statements'
  ]

  defaults:
    fql_statements: []
    data_source: {}
    height: 480
    settings: {}
    settings_active: true
    width: 640

  parse: (response) ->
    if response?.fql_statements is null
      response.fql_statements = []
    if response?.selected_uids is null
      response.selected_uids = []
    response

  initialize: ->
    unless @get('name') then @set 'name', "#{@get('tool_type')}-#{@collection.length + 1}"

    @on 'add:fql_statements', => @save()

    if @isNew()
      @generatePosition()
      @collection.focus @, false
     
      config = @config[@get('tool_type')]
      if config
        @set 'height', config.height if config.height?
        @set 'width', config.width if config.width?
        @set 'locked_size', config.locked if config.locked?
        @get('settings').set config.defaults if config.defaults?
        @get('data_source').set config.data_source if config.data_source?

      @once 'sync', =>
        @get('data_source').set 'tool_id', @id
        @trigger 'tool-initialize'
    else
      @get('data_source').set 'tool_id', @id
      @trigger 'tool-initialize'

  createUbretTool: =>
    sources = @manager.get('sources')
      .config[@manager.get('project')].sources

    if @get('tool_type') in sources
      @tool = new Ubret.BaseTool
        selectIds: @get('selected_uids')
      @updateData(true)
      if @get('tool_type') is 'Zooniverse'
        @on 'change:data_source.params[0].val', @updateData
    else
      @tool = new Ubret[@get('tool_type')]
        selector: (@get('tool_type') + "-" + @cid)
        height: parseInt(@get('height')) - 25
        width: parseInt(@get('width'))

    @tool.on 
      'selection': @selectElements
      'settings': @assignSetting

    @on 
      'change:data_source.source_id': @setupUbretTool
      'change:height' : => @tool.height(parseInt(@get('height')) - 25)
      'change:width' : => @tool.width(parseInt(@get('width')))
      'add:fql_statements' : @sendStatement
      'remove:fql_statements' : @resetStatements
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
    if @get('data_source').isInternal() and @get('data_source.source_id')?
      @sourceTool().on 'change:name', => @trigger 'update-name'
      if @sourceTool().tool?
        @tool.parentTool(@sourceTool().tool) 
      else
        @trigger 'loading'
        @sourceTool().once 'ubret-created', (tool) =>
          @tool.parentTool tool

    else if @get('data_source').isExternal()
      @updateData(force)

    @tool.selectIds(@get('selected_uids'))
      .settings(@get('settings').toJSON())
      .filters(@get('fql_statements')?.filters())
      .fields(@get('fql_statements')?.fields())

  sourceTool: =>
    if @get('data_source').isInternal()
      @collection.get(@get('data_source.source_id'))
    else
      false

  destroy: =>
    children = @collection.filter (tool) =>
      @id is tool.get('data_source').get('source_id') and 
        tool.get('data_source').isInternal()
    child.destroy() for child in children
    super

  sourceName: =>
    if @get('data_source').isExternal()
      @manager.get('sources').get(@get('data_source.source_id')).name
    else if @get('data_source').isZooniverse()
      "Zooniverse"
    else if @get('data_source').isInternal()
      @sourceTool()?.get('name')
    else
      ''

  selectElements: (ids) =>
    if ((_.difference((@get('selected_uids') or []), ids).length) or 
        (_.difference(ids, (@get('selected_uids') or [])).length))
      @updateFunc 'selected_uids', ids

  assignSetting: (setting) =>
    @get('settings').set setting, {silent: true}
    @updateFunc() if @get('settings').hasChanged()

  sendStatement: (statement) =>
    if statement.isFilter()
      @tool.filters(statement.get('func'))
    else
      @tool.fields(statement.attributes)

  resetStatements: () =>
    statements = @get('fql_statements')
    @tool.filters(statements.filters(), true, true)
    @tool.fields(statements.fields(), true, true)

  updateData: (force=false) =>
    force = not(typeof force is 'object')
    dataSource = @get('data_source')
    if dataSource.isZooniverse() 
      if dataSource.get('params[0]').hasChanged or force
        unless _.isEmpty(dataSource.get('params[0].val'))
          @fetchData(dataSource) 
    else if dataSource.isExternal()
      if dataSource.get('params').isValid()
        @fetchData(dataSource)

  fetchData: (dataSource) =>
    data = dataSource.data()
    @trigger('loading')
    data.fetch()
      .done(=> 
        @trigger 'loaded'
        @tool.data(data.toJSON()))
      .error(=> @trigger 'loading-error')

module.exports = Tool