class Tool extends Backbone.AssociatedModel
  sync: require 'sync' 

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
    active: true
    data_source: {}
    height: 480
    settings: {}
    width: 640
    zindex: 1

  initialize: ->
    unless @get('name') then @set 'name', "#{@get('tool_type')}-#{@collection.length + 1}"
    unless @get('channel') then @set 'channel', "#{@get('tool_type')}-#{@collection.length + 1}"
    
    if @isNew()
      @save [],
        success: =>
          @get('data_source').set
            toolId: @id
    else
      @set 'data_source.toolId', @id
      
    super

  # initialize: ->
  #   unless @get('name') then @set 'name', "#{@get('tool_type')}-#{@collection.length + 1}"
  #   unless @get('channel') then @set 'channel', "#{@get('tool_type')}-#{@collection.length + 1}"

  #   if @isNew()
  #     @save [],
  #       success: =>
  #         console.log @
  #         @get('data_source').set
  #           toolId: @id
  #   else
  #     @set 'data_source.toolId', @id

  # toJSON: =>
  #   json = new Object
  #   json[key] = value for key, value of @attributes
  #   json['data_source'] = @get('data_source').toJSON()
  #   json['settings'] = @get('settings').toJSON()
  #   json

  generatePosition: ->
    doc_width = $(document).width()
    doc_height = $(document).height()
    toolbox_bot = 168 # tool box height

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