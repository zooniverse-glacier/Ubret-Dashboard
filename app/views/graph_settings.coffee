BaseView = require 'views/base_view'

class GraphSettings extends BaseView
  tagName: 'div'
  className: 'graph-settings'
  template: require './templates/graph_settings'

  events:
    'change .axis'  : 'onChangeAxis'

  initialize: ->
    @keys = new Array
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
    @model.settings.set(axis, e.target.value)
  
module.exports = GraphSettings