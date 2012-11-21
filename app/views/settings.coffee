UbretView = require 'views/ubret_view'

DataSettings = require 'views/data_settings'
FilterSettings = require 'views/filter_settings'

class Settings extends UbretView
  className: 'settings'
  template: require './templates/settings'

  initialize: ->
    unless @model?
      return
    @dataSettings = new DataSettings { model: @model } if @model?
    @filterSettings = new FilterSettings { model: @model }
    switch @model?.get('type')
      when 'Histogram', 'Scatterplot', 'Histogram2', 'Scatter2D'
        ToolSettings = require 'views/graph_settings'
      when 'Statistics'
        ToolSettings = require 'views/key_settings'
      when 'SubjectViewer'
        ToolSettings = require 'views/subject_settings'
      else # Temp
        ToolSettings = require 'views/generic_settings'

    @toolSettings = new ToolSettings { model: @model}

  render: =>
    @$el.html @template()
    @assign
      '.data-settings': @dataSettings
      '.filter-settings': @filterSettings
      '.tool-settings': @toolSettings
    @

  toggleState: =>
    @$el.toggleClass('active')


module.exports = Settings
