BaseView = require 'views/base_view'

class GraphSettings extends BaseView
  tagName: 'div'
  className: 'graph-settings'
  template: require 'views/templates/graph_settings'

  events:
    'change .axis': 'onChangeAxis'

  initialize: ->
    @keys = []
    Backbone.Mediator.subscribe("#{@model?.get('channel')}:keys", @setKeys)

  render: =>
    @$el.html @template({keys: @keys, currentKey: @model.get('selected_key'), type: @model?.get('tool_type')})
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  # Events
  onChangeAxis: (e) =>
    axis = "axis#{e.target.dataset.axis}"
    @model.get('settings').set(axis, e.target.value)
  
module.exports = GraphSettings