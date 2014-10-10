BaseView = require 'views/base_view'

class GraphSettings extends BaseView
  tagName: 'div'
  className: 'graph-settings'
  template: require 'views/templates/settings/graph'

  events:
    'change .axis': 'onChangeAxis'
    'change .x-min, .x-max, .y-min, .y-max': 'setRange'

  initialize: ->
    @keys = []
    @model.tool.on 'keys', @setKeys

  render: =>
    @$el.html @template
      keys: @keys 
      type: @model.get('tool_type')
      axis1: @model.get('settings.axis1')
      axis2: @model.get('settings.axis2')
      xmin: @model.get('settings.x-min')
      xmax: @model.get('settings.x-max')
      ymin: @model.get('settings.y-min')
      ymax: @model.get('settings.y-max')
    @

  setKeys: (keys) =>
    if _.difference(keys, @keys).length or _.difference(@keys, keys).length
      @keys = keys
      @render()

  # Events
  onChangeAxis: (e) =>
    axis = "axis#{e.target.dataset.axis}"
    set = {}
    set[axis] = e.target.value
    @model.tool.settings(set)

  setRange: (e) =>
    range = e.target.className
    value = e.target.value
    set = {}
    set[range] = parseFloat(value)
    @model.tool.settings(set)

module.exports = GraphSettings
