Settings = require 'collections/settings'

class GraphSettings extends Backbone.View
  tagName: 'div'
  className: 'graph-settings'
  template: require './templates/graph_settings'

  events:
    'change .x-axis' : 'onChangeXAxis'
    'change .y-axis' : 'onChangeYAxis'

  initialize: ->
    @settings = new Settings
    @settings.add [
        name: 'xaxis'
      ,
        name: 'yaxis'
    ]
    @model.set 'settings', @settings

    Backbone.Mediator.subscribe("#{@model.get('channel')}:keys", @setKeys)

  render: =>
    @$el.append @template({ keys: @keys, currentKey: @model.get('selectedKey') })
    @disableYAxis() if @model?.get('type') is 'histogram'
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  disableYAxis: =>
    @$('.y').hide()

  # Events
  onChangeXAxis: (e) =>
    setting = @settings.find (setting) ->
      setting.get('name') == 'xaxis'
    setting.set 'value', $(e.currentTarget).val()
    @model.get('tool').setXVar(setting.get('value'))

  onChangeYAxis: (e) =>
    setting = @settings.find (setting) ->
      setting.get('name') is 'yaxis'
    setting.set 'value', $(e.currentTarget).val()
    @model.get('tool').setYVar(setting.get('value'))


module.exports = GraphSettings