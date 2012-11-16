DataSettings = require 'views/data_settings'
FilterSettings = require 'views/filter_settings'

class Settings extends Backbone.View
  tagName: 'div'
  className: 'settings'

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

    if ToolSettings?
      @toolSettings = new ToolSettings { model: @model}
    else
      @toolSettings = null

  render: =>
    _.each [@dataSettings, @filterSettings, @toolSettings], (subSetting) =>
      @$el.append subSetting?.render().el
    @


module.exports = Settings
