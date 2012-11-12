Settings = require 'collections/settings'

class GraphSettings extends Backbone.View
  tagName: 'div'
  className: 'graph-settings'
  template: require './templates/graph_settings'

  events:
    'change .x-axis'  : 'onChangeXAxis'
    'change .y-axis'  : 'onChangeYAxis'
    'change .axis'    : 'onChangeAxis'

  initialize: ->
    @settings = new Settings
    @settings.add [
        name: 'xaxis'
      ,
        name: 'yaxis'
    ]
    @model?.set 'settings', @settings

    Backbone.Mediator.subscribe("#{@model?.get('channel')}:keys", @setKeys)

  render: =>
    @$el.append @template({ keys: @keys, currentKey: @model.get('selectedKey'), type: @model?.get('type') })
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  # Events
  onChangeAxis: (e) =>
    axis = e.target.dataset.axis
    value = e.target.value
    @model.get('tool').setAxis(axis, value)
  
  onChangeXAxis: (e) =>
    setting = @settings.find (setting) ->
      setting.get('name') is 'xaxis'
    setting.set 'value', $(e.currentTarget).val()
    
    @model.get('tool').setXVar(setting.get('value'))

  onChangeYAxis: (e) =>
    setting = @settings.find (setting) ->
      setting.get('name') is 'yaxis'
    setting.set 'value', $(e.currentTarget).val()
    @model.get('tool').setYVar(setting.get('value'))


module.exports = GraphSettings