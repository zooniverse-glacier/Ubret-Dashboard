BaseView = require 'views/base_view'
DataSettings = require 'views/settings/data'
ToolSettingsConfig = require 'config/tool_settings_config'

class Settings extends BaseView
  className: 'settings'
  template: require './templates/settings'

  events:
    'click .toggle': 'toggleState'
    'click .prev.title-bar-icon' : 'prev'
    'click .next.title-bar-icon' : 'next'

  initialize: ->
    @listenTo @model, 'change:settings_active', @render

    unless @model?
      return

    @dataSettings = new DataSettings { model: @model } if @model?

    setting = ToolSettingsConfig[@model.get('tool_type')]
    @toolSettings = new setting { model: @model }
    
  render: =>
    @$el.html @template(@model.toJSON())

    if @model.get 'settings_active'
      @$el.addClass 'active'
    else
      @$el.removeClass 'active'

    @assign
      '.data-settings': @dataSettings
      '.tool-settings': @toolSettings
    @

  next: =>
    @toolSettings.next()

  prev: =>
    @toolSettings.prev()

  # Events
  toggleState: =>
    @model.save('settings_active', !@model.get('settings_active'))

module.exports = Settings