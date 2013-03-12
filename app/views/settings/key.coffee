BaseView = require 'views/base_view'

class KeySettings extends BaseView
  tagName: 'div'
  className: 'key-settings'
  template: require 'views/templates/settings/key'

  events:
    'change .select-key' : 'onSelectKey'

  initialize: ->
    @model.on 'change:selected_keys', @render
    @model.tool.on 'keys', @setKeys

  render: =>
    @currentKey = if @model.get('selected_keys')? then @model.get('selected_keys')[0] else ''
    @$el.html @template({ keys: @keys, currentKey: @currentKey })
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  #Events
  onSelectKey: (e) =>
    @model.tool.selectKeys([e.currentTarget.value]).start()

module.exports = KeySettings