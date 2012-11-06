class UbretTool extends Backbone.View
  tagName: 'div'
  className: 'ubret-tool'
  nonDisplayKeys: ['id']
  noDataTemplate: require './templates/no_data'

  initialize: ->
    @tool_events = []
    @model?.get('dataSource').on 'change:source', =>
      @model.get('dataSource').get('data').on 'reset', @render
    # try
    #   @template = require "./templates/#{@model?.get('type')}"
    # catch error
    #   @template = ''

  render: =>
    data = @model.getData()
    if data.length is 0
      @$el.html @noDataTemplate()
    else
      # @$el.html @template(@) if typeof @template is 'function'
      opts =
        data: _.map( data, (datum) -> datum.toJSON() )
        selector: '#' + @id
        keys: @dataKeys(data)
        selectElementCb: @selectElement
        selectKeyCb: @selectKey
      
      @tool = new Ubret[@formatToolType(@model.get('type'))](opts)
      @$el.html @tool.getTemplate()
      @tool.start()
    @

  selectById: (id) ->
    @model.set 'currentSubject', @id

  dataKeys: (data) =>
    dataModel = data[0].toJSON()
    keys = new Array
    for key, value of dataModel
      keys.push key unless key in @nonDisplayKeys
    return keys

  formatToolType: (toolType)=>
    toolType.charAt(0).toUpperCase() + toolType.slice(1)

  selectElement: (id) =>
    console.log id

  selectKey: (key) =>
    console.log key

module.exports = UbretTool