BaseView = require 'views/base_view'

DataSettings = require 'views/data_settings'
FilterSettings = require 'views/filter_settings'

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
    switch @model?.get('type')
      when 'Histogram', 'Scatterplot', 'Histogram2', 'Scatter2D'
        ToolSettings = require 'views/graph_settings'
      when 'Statistics'
        ToolSettings = require 'views/key_settings'
      when 'SubjectViewer', "Spectra"
        ToolSettings = require 'views/subject_settings'
      when 'Map'
        ToolSettings = require 'views/map_settings'
      when 'Table'
        ToolSettings = require 'views/table_page_settings'
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