BaseView = require 'views/base_view'

class UbretTool extends BaseView
  nonDisplayKeys: ['id', 'uid', 'image']
  noDataTemplate: require './templates/no_data'

  initialize: ->
    if @model?
      @model.on 'change:selected_ids', @toolSelectElements
      @model.on 'change:selected_keys', @toolSelectKey
      @model.on 'change:settings', @passSetting
      @model.on 'change:data_source', @render

    @model.tool = new Ubret[@model.get('tool_type')]('#' + @model.get('channel'))
    @model.tool.on 'keys-received', (keys) =>
      Backbone.Mediator.publish("#{@model?.get('channel')}:keys", keys)
    @model.tool.on 'selection', @selectElements
    @model.tool.on 'keys-selection', @selectKeys

  render: =>
    @$el.addClass @model.get('type')
    @$el.attr 'id', @model.get('channel')

    if @model.get('data_source').isReady() 
      @$('.no-data').remove()
      if @model.get('data_source').isInternal()
        @model.tool.parentTool(@model.get('data_source').source.tool)
      else
        @model.tool.data(@model.get('data_source').data.toJSON())
          .keys(@dataKeys(@model.get('data_source').data.toJSON()[0]))

      @model.tool.selectIds(@model.get('selected_ids'), false)
        .selectKeys(@model.get('selected_keys'), false)
        .settings(@model.get('settings').toJSON())
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

  selectKeys: (key) =>
    console.log 'sk model', @model
    @model.save 'selected_keys', key

  toolSelectKey: =>
    @model.tool.selectKeys(@model.get('selected_keys')).start()

  toolSelectElements: =>
    @model.tool.selectIds(@model.get('selected_ids').slice()).start()

  toolAddFilters: =>
    @model.tool.filters(@model.filters.toJSON()).start()

  passSetting: =>
    @model.tool.settings(@model.get('settings').changed).start()

module.exports = UbretTool