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
    console.log 'rendering settings'
    @$el.append @template({ keys: @keys, currentKey: @model.get('selectedKey') })
    @disableYAxis() if @model?.get('type') is 'histogram'
    @

  setKeys: (keys) =>
    console.log 'setting keys'
    @keys = keys
    @render()

  disableYAxis: =>
    @$('select.y-axis').attr('disabled', 'disabled')

  # Events
  onChangeXAxis: (e) =>
    setting = @settings.find (setting) ->
      setting.get('name') == 'xaxis'
    console.log setting
    setting.set 'value', $(e.currentTarget).val()
    @model.get('tool').selectedKey = setting.get 'value'
    console.log @model.get('tool')
    @model.get('tool').start()

  onChangeYAxis: (e) =>
    setting = @settings.find (setting) ->
      setting.name is 'yaxis'
    setting.set 'value', $(e.currentTarget).val()
    # @model.get('tool').selectedKey = setting.get 'value'
    # @model.get('tool').start()


module.exports = GraphSettings