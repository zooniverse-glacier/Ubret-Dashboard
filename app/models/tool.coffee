class Tool extends Backbone.AssociatedModel
  sync: require 'sync' 

  relations: [
    type: Backbone.One
    key: 'dataSource'
    relatedModel: require 'models/data_source'
  ,
    type: Backbone.One
    key: 'settings'
    relatedModel: require 'models/settings'
  ]

  defaults:
    zindex: 1
    height: 480
    width: 640
    active: true
    dataSource: {} 
    settings: {} 

  initialize: ->
    console.log 'creating tool', @
    unless @get('name') then @set 'name', "#{@get('type')}-#{@collection.length + 1}"

  toJSON: =>
    json = new Object
    json[key] = value for key, value of @attributes
    json['settings'] = @get('settings').toJSON()
    json

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