BaseView = require 'views/base_view'

class GraphSettings extends BaseView
  tagName: 'div'
  className: 'graph-settings'
  template: require 'views/templates/settings/graph'

  events:
    'change .axis': 'onChangeAxis'
    'click button.bin' : 'updateBins'

  initialize: ->
    @keys = []
    Backbone.Mediator.subscribe("#{@model?.get('channel')}:keys", @setKeys)

  render: =>
    @$el.html @template
      keys: @keys 
      currentKey: @model.get('selected_key') 
      type: @model.get('tool_type')
      bins: @model.get('settings').get('bins')
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  # Events
  onChangeAxis: (e) =>
    axis = "axis#{e.target.dataset.axis}"
    set = {}
    set[axis] = e.target.value
    @model.tool.settings(set).start()

  updateBins: (e) =>
    bins = @$('input.bins').val().split(',')
    bins[index] = value.replace(/\s+/g, '') for value, index in bins
    bins = bins[0] if bins.length is 1

    @model.tool.settings({bins: bins}) unless bins is ''
  
module.exports = GraphSettings