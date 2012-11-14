class FilterSettings extends Backbone.View
  tagName: 'div'
  className: 'filter-settings'
  template: require './templates/filter_settings'

  events: 
    'click button[name="filter"]' : 'addFilter'

  initialize: ->
    @collection?.on 'add', @render

  addFilter: (e) =>
    extents = @model.get('dataSource').dataExtents @model.get('selectedKey'), @model.get('selectedElements')
    @collection.add
      key: @model.get('selectedKey')
      min: extents.min
      max: extents.max
      text: "#{@model.get('selectedKey')} from #{extents.min} to #{extents.max}"

  render: =>
    filters = @collection?.toJSON || []
    @$el.html @template({filters: filters})
    @

module.exports = FilterSettings