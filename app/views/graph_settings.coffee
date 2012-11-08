class GraphSettings extends Backbone.View
  tagName: 'div'
  className: 'graph-settings'
  template: require './templates/graph_settings'

  initialize: ->
    Backbone.Mediator.subscribe("#{@model.get('channel')}:keys", @setKeys)

  render: =>
    console.log 'rendering settings'
    @$el.append @template({ keys: @keys, currentKey: @model.get('selectedKey') })
    @disableYAxis() if @model?.get('type') is 'histogram'
    @

  setKeys: =>
    @keys = _.keys(@model.get('dataSource').get('data').models[0].attributes)
    @render()

  disableYAxis: =>
    @$('select.y-axis').attr('disabled', 'disabled')

module.exports = GraphSettings
