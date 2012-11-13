class GraphSettings extends Backbone.View
  tagName: 'div'
  className: 'graph-settings'
  template: require './templates/graph_settings'

  events:
    'change .axis'    : 'onChangeAxis'

  initialize: ->
    Backbone.Mediator.subscribe("#{@model?.get('channel')}:keys", @setKeys)

  render: =>
    @$el.append @template({ keys: @keys, currentKey: @model.get('selectedKey'), type: @model?.get('type') })
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  # Events
  onChangeAxis: (e) =>
    axis = if e.target.dataset.axis is '1' then 'xAxis' else 'yAxis'
    value = e.target.value
    @model.get('settings').set axis, value
  
module.exports = GraphSettings