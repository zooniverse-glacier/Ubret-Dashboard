class UbretTool extends Backbone.View
  tagName: 'div'
  className: 'ubret-tool'
  nonDisplayKeys: ['id']
  noDataTemplate: require './templates/no_data'

  initialize: ->
    @tool_events = []
    @model?.get('dataSource').on 'new-data', @render
    @model?.on 'change:selectedElement', @toolSelectElement
    @model?.on 'change:selectedKey', @toolSelectKey

  render: =>
    data = @model.getData()
    if data.length is 0
      @$el.html @noDataTemplate()
    else
      opts =
        data: _.map( data, (datum) -> datum.toJSON() )
        selector: '#' + @id
        keys: @dataKeys(data)
        selectElementCb: @selectElement
        selectKeyCb: @selectKey

      @tool = new Ubret[@formatToolType(@model.get('type'))](opts)
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
    @model.set 'selectedElement', id

  selectKey: (key) =>
    @model.set 'selectedKey', key

  toolSelectKey: =>
    @tool.selectKey @model.get('selectedKey')

  toolSelectElement: =>
    @tool.selectElement @model.get('selectedElement')


module.exports = UbretTool