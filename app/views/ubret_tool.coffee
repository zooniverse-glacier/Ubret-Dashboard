class UbretTool extends Backbone.View
  tagName: 'div'
  className: 'ubret-tool'
  nonDisplayKeys: []
  noDataTemplate: require './templates/no_data'

  initialize: ->
    @tool_events = []
    @model?.get('dataSource').on 'new-data', @render
    @model?.on 'change:selectedElement', @toolSelectElements
    @model?.on 'change:selectedKey', @toolSelectKey
    @model?.get('filters').on 'add reset', @toolAddFilter
    @model?.get('settings').on 'change', @passSetting

  render: =>
    data = @model.getData()
    if data.length is 0
      @$el.html @noDataTemplate()
    else
      opts =
        data: _.map( data, (datum) -> datum.toJSON() )
        selector: '#' + @id
        keys: @dataKeys(data)
        selectElementsCb: @selectElements
        selectedElements: @model.get('selectedElements')
        selectKeyCb: @selectKey
        selectedKey: @model.get('selectedKey')
        filters: @model.get('filters').models
        el: @$el
        width: @model.get('width')
        height: @model.get('height') - 30
        filters: @model.get('filters').models

      @tool = new Ubret[@model.get('type')](opts)
    @

  dataKeys: (data) =>
    dataModel = data[0].toJSON()
    keys = new Array
    for key, value of dataModel
      keys.push key unless key in @nonDisplayKeys
    Backbone.Mediator.publish("#{@model.get('channel')}:keys", keys)
    return keys

  selectElements: (ids) =>
    @model.set 'selectedElements', ids

  selectKey: (key) =>
    @model.set 'selectedKey', key

  toolSelectKey: =>
    @tool.selectKey @model.get('selectedKey')

  toolSelectElements: =>
    @tool.selectElements @model.get('selectedElements')

  toolAddFilters: =>
    @tool.addFilter @model.get('filters').models

  passingSetting: =>
    @tool.receiveSetting {key: value} for key, value of @model.get('settings').changed

module.exports = UbretTool