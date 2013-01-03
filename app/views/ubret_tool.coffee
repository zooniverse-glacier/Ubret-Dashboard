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
    @tool = new Ubret[@model.get('type')]('#' + @id)

  render: =>
    if (not @model.dataSource.data?) or (@model.dataSource.data.length is 0)
      @$el.html @noDataTemplate()
    else
      console.log @model.get('selectedElements')
      @$('.no-data').remove()
      @tool.parentTool(@model.dataSource.source) if @model.dataSource.isInternal()
      @tool.data(@model.dataSource.data.toJSON())
        .keys(@dataKeys(@model.dataSource.data.toJSON()[0]))
        .selectIds(@model.get('selectedElements'))
        .selectKeys(@model.get('selectedKey'))
        .settings(@model.settings.toJSON())
        #.filters(@model.filters)
        .start()
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
    @tool.settings @model.settings.changed

module.exports = UbretTool