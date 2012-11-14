class GraphSettings extends Backbone.View
  tagName: 'div'
  className: 'graph-settings'
  template: require './templates/graph_settings'

  events:
    'change .axis'  : 'onChangeAxis'

  initialize: ->
    Backbone.Mediator.subscribe("#{@model?.get('channel')}:keys", @setKeys)

  render: =>
    @$el.html @template({ keys: @keys, currentKey: @model.get('selectedKey'), type: @model?.get('type') })
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  # Events
  onChangeAxis: (e) =>
    axis = "axis#{e.target.dataset.axis}"
    console.log "onChangeAxis", axis, e.target.value
    @model.get('settings').set(axis, e.target.value)
  
module.exports = GraphSettings