BaseView = require 'views/base_view'
DataSettings = require 'views/settings/data'

class Settings extends BaseView
  className: 'settings'
  template: require './templates/settings'

  events:
    'click .toggle': 'toggleState'

  initialize: ->
    @active = @model.get('active')
    unless @model?
      return
    @dataSettings = new DataSettings { model: @model } if @model?
    switch @model?.get('tool_type')
      when 'Histogram', 'Scatterplot', 'Histogram2', 'Scatter2D'
        ToolSettings = require 'views/settings/graph'
      when 'Statistics'
        ToolSettings = require 'views/settings/key'
      when 'SubjectViewer', "Spectra"
        ToolSettings = require 'views/settings/subject'
      when 'Map'
        ToolSettings = require 'views/settings/map'
      when 'Table'
        ToolSettings = require 'views/settings/table'
      else # Temp
        ToolSettings = require 'views/settings/generic'

    @toolSettings = new ToolSettings {model: @model}

  render: =>
    @$el.html @template()
    @assign
      '.data-settings': @dataSettings
      '.tool-settings': @toolSettings
    @

  # Events
  toggleState: =>
    if @active is false
      @active = true
      @render()
    else
      @active = false
      @dataSettings.remove()
      @toolSettings.remove()
    @model.save('active', @active)
    @$el.toggleClass('active')

module.exports = Settings