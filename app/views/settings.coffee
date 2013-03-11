BaseView = require 'views/base_view'

class Settings extends BaseView
  className: 'settings'
  template: require './templates/settings'
  config: require 'config/tool_settings_config'

  events:
    'click .toggle': 'toggleState'
    'click .prev.title-bar-icon' : 'prev'
    'click .next.title-bar-icon' : 'next'
    'click h4' : 'hideSetting'

  initialize: ->
    @listenTo @model, 'change:settings_active', @render
    @toolSettings = new Array
    for setting in @config[@model.get('tool_type')].settings
      @toolSettings.push new setting { model: @model }
    
  render: =>
    @$el.html @template(@model.toJSON())
    if @model.get 'settings_active'
      @$el.addClass 'active'
      for setting in @toolSettings
        @$('.settings-group').append setting.render().el 
        setting.delegateEvents()
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