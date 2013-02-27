BaseView = require 'views/base_view'

class UbretTool extends BaseView
  nonDisplayKeys: ['id', 'uid', 'image', 'thumb']
  noDataTemplate: require './templates/no_data'

  initialize: (options) ->
    @model.on 'render', @render

    @model.once 'started', =>
      @listenTo @model, 'change:selected_uids', @toolSelectElements
      @listenTo @model, 'change:selected_keys', @toolSelectKey
      @listenTo @model, 'change:height, change:width', @render

      # Assume @model.tool has been created.
    @model.tool = new Ubret[@model.get('tool_type')]("##{@model.get('tool_type')}-#{@model.cid}")

    @model.tool.on 'keys-received', (keys) =>
      Backbone.Mediator.publish("#{@model.id}:keys", keys)
    @model.tool.on 'selection', @selectElements
    @model.tool.on 'keys-selection', @selectKeys
    @model.tool.on 'update-setting', @assignSetting

  render: =>
    @$el.addClass @model.get('tool_type')
    @$el.attr 'id', "#{@model.get('tool_type')}-#{@model.cid}"
   
    if @model.isReady()
      @$('.no-data').remove()
      @drawTool()
    else
      @$el.html @noDataTemplate()
    @

  drawTool: =>
    @setHeight()
    if @model.get('data_source').isInternal()
      @model.tool.parentTool(@model.sourceTool().tool) 
    else
      @model.tool.removeParentTool()
      @model.tool.data(@model.get('data_source').data.toJSON())
        .keys(@model.get('data_source').dataKeys())

    @model.tool.selectIds(@model.get('selected_uids'))
      .selectKeys(@model.get('selected_keys'))
      .settings(@model.get('settings').toJSON())
      .start()

    @model.trigger 'started'

  # From Ubret tool to @model
  selectElements: (ids) =>
    if _.difference(ids, @model.get('selected_uids')).length
      @model.save 'selected_uids', ids

  selectKeys: (key) =>
    if _.difference(key, @model.get('selected_keys')).length
      @model.save 'selected_keys', key

  assignSetting: (setting) =>
    @model.get('settings').set setting, {silent: true}
    @model.save()

  setHeight: =>
    @$el.height(@model.get('height') - 25)

module.exports = UbretTool