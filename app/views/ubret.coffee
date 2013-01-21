BaseView = require 'views/base_view'

class UbretTool extends BaseView
  nonDisplayKeys: ['id', 'uid', 'image']
  noDataTemplate: require './templates/no_data'

  initialize: ->
    if @model?
      @model.on 'change:selectedElements', @toolSelectElements
      @model.on 'change:selectedKey', @toolSelectKey
      @model.settings.on 'change', @passSetting
      @model.on 'tool:dataProcessed', @render

    @model.tool = new Ubret[@model.get('type')]('#' + @model.get('channel'))
    @model.tool.on 'keys-received', (keys) =>
      Backbone.Mediator.publish("#{@model?.get('channel')}:keys", keys)
    @model.tool.on 'selection', @selectElements
    @model.tool.on 'key-selection', @selectKey

  render: =>
    @$el.addClass @model.get('type')
    @$el.attr 'id', @model.get('channel')

    if @model.dataSource.isReady() 
      @$('.no-data').remove()
      if @model.dataSource.isInternal()
        @model.tool.parentTool(@model.dataSource.source.tool)
      else
        @model.tool.data(@model.dataSource.data.toJSON())
          .keys(@dataKeys(@model.dataSource.data.toJSON()[0]))

      @model.tool.selectIds(@model.get('selectedElements'))
        .selectKeys([@model.get('selectedKey')])
        .settings(@model.settings.toJSON())
        .start()
    else
      @$el.html @noDataTemplate()
    @

  dataKeys: (dataModel) =>
    keys = new Array
    for key, value of dataModel
      keys.push key unless key in @nonDisplayKeys
    return keys

  selectElements: (ids) =>
    @model.setElements ids

  selectKey: (key) =>
    @model.save 'selectedKey', key

  toolSelectKey: =>
    @model.tool.selectKeys(@model.get('selectedKey').slice()).start()

  toolSelectElements: =>
    @model.tool.selectIds(@model.get('selectedElements').slice()).start()

  toolAddFilters: =>
    @model.tool.filters(@model.filters.toJSON()).start()

  passSetting: =>
    @model.tool.settings(@model.settings.changed).start()

module.exports = UbretTool