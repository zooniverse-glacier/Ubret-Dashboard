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

    @toolSettings = new Array
    for setting in ToolSettingsConfig[@model.get('tool_type')]
      @toolSettings.push new setting { model: @model }
    
  render: =>
    @$el.html @template(@model.toJSON())
    if @model.get 'settings_active'
      @$el.addClass 'active'
      @assign '.data-settings', @dataSettings
      @$el.append setting.render().el for setting in @toolSettings
    else
      @$el.removeClass 'active'
      @dataSettings.$el.detach()
      setting.$el.detach() for setting in @toolSettings
    @

  next: =>
    @toolSettings[0].next()

  prev: =>
    @toolSettings[0].prev()

  # Events
  toggleState: =>
    @model.save('settings_active', !@model.get('settings_active'))

module.exports = Settings