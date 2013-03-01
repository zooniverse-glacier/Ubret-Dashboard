BaseView = require 'views/base_view'

class UbretTool extends BaseView
  nonDisplayKeys: ['id', 'uid', 'image', 'thumb']
  noDataTemplate: require './templates/no_data'

  initialize: (options) ->
    @model.tool = new Ubret[@model.get('tool_type')]("##{@model.get('tool_type')}-#{@model.cid}")

    @model.tool.on 'keys-received', @publishKeys
    @model.tool.on 'selection', @selectElements
    @model.tool.on 'keys-selection', @selectKeys
    @model.tool.on 'update-setting', @assignSetting
    @model.tool.on 'data-received', @render
    @drawTool()

    @model.get('data_source').on 'change', @drawTool
    @model.on 'change:height change:width', @render

  render: =>
    @$el.addClass @model.get('tool_type')
    @$el.attr 'id', "#{@model.get('tool_type')}-#{@model.cid}"
    unless _.isEmpty(@model.tool.opts.data)
      @$('.no-data').remove()
      @model.tool.opts.height = parseInt(@model.get('height'))
      @model.tool.start()
    else
      @$el.append @noDataTemplate()
    @

  drawTool: =>
    if @model.get('data_source').isInternal()
      @model.tool.parentTool(@model.sourceTool().tool) 
    else if @model.get('data_source').isExternal()
      @model.tool.removeParentTool()
      data = @model.get('data_source').data()
      data.fetch().done =>
        @model.tool.keys(@dataKeys(data))
          .data(data.toJSON())

    @model.tool.selectIds(@model.get('selected_uids'))
      .selectKeys(@model.get('selected_keys'))
      .settings(@model.get('settings').toJSON())

    @model.trigger 'started'

  # From Ubret tool to @model
  selectElements: (ids) =>
    if _.difference(ids, @model.get('selected_uids')).length
      @model.updateFunc 'selected_uids', ids

  selectKeys: (key) =>
    if _.difference(key, @model.get('selected_keys')).length
      @model.updateFunc 'selected_keys', key

  assignSetting: (setting) =>
    @model.get('settings').set setting, {silent: true}
    @model.updateFunc() if @model.get('settings').hasChanged()

  # Helper
  dataKeys: (data) =>
    keys = new Array
    for key, value of data.toJSON()[0]
      keys.push key unless key in @nonDisplayKeys
    return keys

  publishKeys: (keys) =>
    Backbone.Mediator.publish("#{@model.id}:keys", keys)

module.exports = UbretTool