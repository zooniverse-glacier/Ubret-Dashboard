class GraphSettings extends Backbone.View
  tagName: 'div'
  className: 'graph-settings'
  template: require './templates/graph_settings'

  initialize: ->
    Backbone.Mediator.subscribe("#{@model?.get('channel')}:keys", @setKeys)

  render: =>
    @$el.html @template({ keys: @keys, currentKey: @model.get('selectedKey') })
    @disableYAxis() if @model.get('type') is 'histogram'
    @

  disableYAxis: =>
    @$('select.y-axis').attr('disabled', 'disabled')

  setKeys: (keys) =>
    @keys = keys

module.exports = GraphSettings