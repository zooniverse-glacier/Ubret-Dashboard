BaseView = require 'views/base_view'

DataSettings = require 'views/data_settings'
FilterSettings = require 'views/filter_settings'

class Settings extends BaseView
  className: 'settings'
  template: require './templates/settings'

  events:
    'click .toggle': 'toggleState'

  initialize: ->
    @active = @model.settings.get('active')
    unless @model?
      return
    @dataSettings = new DataSettings { model: @model } if @model?
    switch @model?.get('type')
      when 'Histogram', 'Scatterplot', 'Histogram2', 'Scatter2D'
        ToolSettings = require 'views/graph_settings'
      when 'Statistics'
        ToolSettings = require 'views/key_settings'
      when 'SubjectViewer'
        ToolSettings = require 'views/subject_settings'
      when 'Map'
        ToolSettings = require 'views/map_settings'
      else # Temp
        ToolSettings = require 'views/generic_settings'

    @toolSettings = new ToolSettings { model: @model}

  render: =>
    @$el.html @template()
    @assign
      '.data-settings': @dataSettings
      '.tool-settings': @toolSettings
    @

  # Events
  toggleState: =>
    @active = if @active then false else true
    @model.settings.set('active', @active)
    @$el.toggleClass('active')

module.exports = Settings