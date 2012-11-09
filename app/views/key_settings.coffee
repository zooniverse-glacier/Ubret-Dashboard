Settings = require 'collections/settings'

class KeySettings extends Backbone.View
  tagName: 'div'
  className: 'key-settings'
  template: require './templates/key_settings'

  events:
    'change .select-key' : 'onSelectKey'

  initialize: ->
    Backbone.Mediator.subscribe("#{@model.get('channel')}:keys", @setKeys)

  render: =>
    @$el.append @template({ keys: @keys, currentKey: @model.get('selectedKey') })
    @

  setKeys: (keys) =>
    @keys = keys
    @render()


  #Events
  onSelectKey: (e) =>
    @model.get('tool').selectKey $(e.currentTarget).val()

module.exports = KeySettings