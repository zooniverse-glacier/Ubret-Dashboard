BaseView = require 'views/base_view'
DataSettings = require 'views/settings/data'

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
    
    switch @model?.get('tool_type')
      when 'Histogram', 'Scatterplot'
        ToolSettings = require 'views/settings/graph'
      when 'Statistics'
        ToolSettings = require 'views/settings/key'
      when 'SubjectViewer', "Spectra"
        ToolSettings = require 'views/settings/subject'
      when 'Mapper'
        ToolSettings = require 'views/settings/map'
      when 'Table'
        ToolSettings = require 'views/settings/table'
      when 'SpacewarpViewer'
        ToolSettings = require 'views/settings/spacewarp_viewer'
      else # Temp
        ToolSettings = require 'views/settings/generic'
    
    @toolSettings = new ToolSettings {model: @model}

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