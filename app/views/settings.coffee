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
    'click h4' : 'hideSetting'

  initialize: ->
    @listenTo @model, 'change:settings_active', @render
    @toolSettings = new Array
    for setting in ToolSettingsConfig[@model.get('tool_type')].settings
      @toolSettings.push new setting { model: @model }

    
  render: =>
    @$el.html @template(@model.toJSON())
    if @model.get 'settings_active'
      @$el.addClass 'active'
      @$('.settings-group').append setting.render().el for setting in @toolSettings
    else
      @$el.removeClass 'active'
      setting.remove() for setting in @toolSettings
    @

  # Events
  toggleState: =>
    @model.updateFunc('settings_active', !@model.get('settings_active'))

  next: =>
    @model.tool.trigger 'next'

  prev: =>
    @model.tool.trigger 'prev'

  hideSetting: (e) =>
    @$(e.currentTarget).siblings().slideToggle()

module.exports = Settings