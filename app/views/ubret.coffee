BaseView = require 'views/base_view'

class UbretTool extends BaseView
  nonDisplayKeys: ['id', 'uid', 'image']
  noDataTemplate: require './templates/no_data'

  initialize: ->
    # An allowance for not having the UI block on tool creation.
    if @model.isNew()
      @model.once 'sync', =>
        console.log 'subscribing to new', "#{@model.get('id')}:dataFetched"
        Backbone.Mediator.subscribe "#{@model.get('id')}:dataFetched", @render
    else
      console.log 'subscribing to ', "#{@model.get('id')}:dataFetched"
      Backbone.Mediator.subscribe "#{@model.get('id')}:dataFetched", @render


    @model.once 'started', =>
      @listenTo @model, 'change:selected_ids', @toolSelectElements
      @listenTo @model, 'change:selected_keys', @toolSelectKey
      @listenTo @model, 'change:settings', @passSetting

    @model.tool = new Ubret[@model.get('tool_type')]('#' + @model.get('channel'))
    @model.tool.on 'keys-received', (keys) =>
      Backbone.Mediator.publish("#{@model?.get('channel')}:keys", keys)
    @model.tool.on 'selection', @selectElements
    @model.tool.on 'keys-selection', @selectKeys

  render: =>
    # console.log 'rendering ubrettool', @model
    @$el.addClass @model.get('tool_type')
    @$el.attr 'id', @model.get('channel')

    if @model.get('data_source').isReady() 
      @$('.no-data').remove()
      if @model.get('data_source').isInternal()
        source = @model.collection.find (tool) =>
          tool.get('channel') is @model.get('data_source').get('source')
        @model.tool.parentTool(source.tool)
      else
        @model.tool.data(@model.get('data_source').data.toJSON())
          .keys(@model.get('data_source').dataKeys())

      @model.tool.selectIds(@model.get('selected_ids'))
        .selectKeys(@model.get('selected_keys'))
        .settings(@model.get('settings').toJSON())
        .start()

      console.log 'triggering started on', @model
      @model.trigger 'started'
    else
      @$el.html @noDataTemplate()
    @

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