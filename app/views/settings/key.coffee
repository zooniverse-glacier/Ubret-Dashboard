BaseView = require 'views/base_view'

class KeySettings extends BaseView
  tagName: 'div'
  className: 'key-settings'
  template: require 'views/templates/key_settings'

  events:
    'change .select-key' : 'onSelectKey'

  initialize: ->
    @model.on 'change:selected_keys', @render
    Backbone.Mediator.subscribe "#{@model.get('channel')}:keys", @process

  render: =>
    @currentKey = if @model.get('selected_keys')? then @model.get('selected_keys')[0] else ''
    @$el.html @template({ keys: @keys, currentKey: @currentKey })
    @

  process: (keys) =>
    @keys = keys
    @render()

  #Events
  onSelectKey: (e) =>
    @model.save 'selected_keys', [@$(e.currentTarget).val()]

module.exports = KeySettings