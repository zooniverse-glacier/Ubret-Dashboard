BaseView = require 'views/base_view'

class UbretTool extends BaseView
  tagName: 'div'
  className: 'ubret-tool'
  nonDisplayKeys: ['id', 'uid', 'image']
  noDataTemplate: require './templates/no_data'

  initialize: ->
    if @model?
      @model.on 'change:selectedElements', @toolSelectElements
      @model.on 'change:selectedKey', @toolSelectKey
      @model.filters.on 'add reset', @toolAddFilters
      @model.settings.on 'change', @passSetting
      @model.on 'tool:dataProcessed', @render

    @$el.addClass @model.get('type')
    @$el.attr 'id', @id

  render: =>
    if (not @model.dataSource.data?) or (@model.dataSource.data.length is 0)
      @$el.html @noDataTemplate()
    else
      @$('.no-data').remove()
      data = @model.dataSource.data.map (datum) ->
        try
          return datum.toJSON()
        catch error
          return datum

      opts =
        data: data
        keys: @dataKeys data[0]
        filters: @model.filters.models
        selectedElements: @model.get('selectedElements')?.slice()
        selectedKey: @model.get('selectedKey')
        el: @$el
        selector: '#' + @id
        selectElementsCb: @selectElements
        selectKeyCb: @selectKey

      _.extend opts, @model.settings.toJSON()
      @tool = new Ubret[@model.get('type')](opts)

      # This is Horrifically ugly
      if $("##{@id}").length isnt 0
        @tool.start()
      else
        setTimeout @tool.start, 500
    @

  dataKeys: (dataModel) =>
    keys = new Array
    for key, value of dataModel
      keys.push key unless key in @nonDisplayKeys
    Backbone.Mediator.publish("#{@model?.get('channel')}:keys", keys)
    return keys

  selectElements: (ids) =>
    @model.setElements ids

  selectKey: (key) =>
    @model.save 'selectedKey', key

  toolSelectKey: =>
    @tool?.selectKey @model.get('selectedKey')

  toolSelectElements: =>
    @tool?.selectElements @model.get('selectedElements').slice()

  toolAddFilters: =>
    @tool.addFilters @model.filters.toJSON()

  passSetting: =>
    @tool.receiveSetting key, value for key, value of @model.settings.changed

module.exports = UbretTool