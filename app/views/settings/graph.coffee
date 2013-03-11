BaseView = require 'views/base_view'

class GraphSettings extends BaseView
  tagName: 'div'
  className: 'graph-settings'
  template: require 'views/templates/settings/graph'

  events:
    'change .axis': 'onChangeAxis'

  initialize: ->
    @keys = []
    @model.tool.on 'keys', @setKeys

  render: =>
    @$el.html @template
      keys: @keys 
      currentKey: @model.get('selected_key') 
      type: @model.get('tool_type')
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  # Events
  onChangeAxis: (e) =>
    axis = "axis#{e.target.dataset.axis}"
    set = {}
    set[axis] = e.target.value
    @model.tool.settings(set)

module.exports = GraphSettings