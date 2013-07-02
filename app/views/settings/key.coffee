BaseView = require 'views/base_view'

class KeySettings extends BaseView
  tagName: 'div'
  className: 'key-settings'
  template: require 'views/templates/settings/key'

  events:
    'change .select-key' : 'onSelectKey'

  initialize: ->
    @model.tool.on 'keys', @setKeys

  render: =>
    @currentKey = @model.get('settings.statKey')
    @$el.html @template({ keys: @keys, currentKey: @currentKey })
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  #Events
  onSelectKey: (e) =>
    @model.tool.settings({statKey: e.currentTarget.value})

module.exports = KeySettings