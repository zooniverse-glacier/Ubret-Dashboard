class GraphSettings extends Backbone.View
  tagName: 'div'
  className: 'graph-settings'
  template: require './templates/graph_settings'

  initialize: ->
    @keys = []
    @currentKey = 'id'

  render: =>
    @$el.html @template({ keys: @keys, currentKey: @currentKey })
    @disableYAxis() if @model?.get('type') is 'histogram'
    @

  disableYAxis: =>
    @$('select.y-axis').attr('disabled', 'disabled')

module.exports = GraphSettings