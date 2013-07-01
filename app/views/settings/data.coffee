BaseView = require 'views/base_view'

class DataSettings extends BaseView
  tagName: 'div'
  className: 'data-settings'
  template: require 'views/templates/settings/data'

  events:
    'change .internal .sources': 'onSelectInternalSource'

  initialize: ->
    @model.collection.on 'tool-initialize remove', @render

  render: (tool=null) =>
    opts = {}
    @updateValidSourceTools()
    opts.intSources = @intSources
    if @model.get('data_source').get('source_id')?
      opts.source = @model.get('data_source').get('source_id')
    @$el.html @template opts
    @

  # Fetch the data.
  onSelectInternalSource: (e) =>
    @model.get('data_source').set
      'source_id': $(e.currentTarget).val()
      'source_type': "internal"
    @model.updateFunc()

  updateValidSourceTools: =>
    @intSources = []
    @model.collection?.each (tool) =>
      unless @model is tool 
        @intSources.push { name: tool.get('name'), id: tool.id }

module.exports = DataSettings