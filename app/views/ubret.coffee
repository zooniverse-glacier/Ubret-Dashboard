BaseView = require 'views/base_view'

class UbretTool extends BaseView
  nonDisplayKeys: ['id', 'uid', 'image']
  noDataTemplate: require './templates/no_data'

  initialize: ->
    if @model?
      @listenTo @model, 'change:selected_ids', @toolSelectElements
      @listenTo @model, 'change:selected_keys', @toolSelectKey
      @listenTo @model, 'change:settings', @passSetting
      @listenTo @model, 'change:data_source', @render

    @model.tool = new Ubret[@model.get('tool_type')]('#' + @model.get('channel'))
    @model.tool.on 'keys-received', (keys) =>
      Backbone.Mediator.publish("#{@model?.get('channel')}:keys", keys)
    @model.tool.on 'selection', @selectElements
    @model.tool.on 'keys-selection', @selectKeys

  render: =>
    @$el.addClass @model.get('tool_type')
    @$el.attr 'id', @model.get('channel')

    if @model.get('data_source').isReady() 
      @$('.no-data').remove()
      if @model.get('data_source').isInternal()
        source = @model.collection.find (tool) =>
          tool.get('channel') is @model.get('data_source').get('source')
        if source.get('data_source').isReady() and (not _.isUndefined(source.tool))
          @model.tool.parentTool(source.tool) 
        else
          @$el.html @noDataTemplate()
          return @
      else
        @model.tool.data(@model.get('data_source').data.toJSON())
          .keys(@dataKeys(@model.get('data_source').data.toJSON()[0]))

      @model.tool.selectIds(@model.get('selected_ids'))
        .selectKeys(@model.get('selected_keys'))
        .settings(@model.get('settings').toJSON())
        .start()

      @model.trigger 'started'
    else
      @$el.html @noDataTemplate()
    @

  dataKeys: (dataModel) =>
    keys = new Array
    for key, value of dataModel
      keys.push key unless key in @nonDisplayKeys
    return keys

  selectElements: (ids) =>
    if _.difference(ids, @model.get('selected_ids')).length
      @model.save 'selected_ids', ids

  selectKeys: (key) =>
    if _.difference(key, @model.get('selected_keys')).length
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