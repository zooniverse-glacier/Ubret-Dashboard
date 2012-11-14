class FilterSettings extends Backbone.View
  tagName: 'div'
  className: 'filter-settings'
  template: require './templates/filter_settings'

  events: 
    'click button[name="filter"]' : 'addFilter'

  initialize: ->
    @model.get('filters')?.on 'add', @render

  addFilter: (e) =>
    key = @model.get('selectedKey') or 'id'
    console.log key
    extents = @model.get('dataSource').dataExtents key, @model.get('selectedElements')
    @model.get('filters').add
      key: @model.get('selectedKey')
      min: extents.min
      max: extents.max
      text: "#{key} from #{extents.min} to #{extents.max}"

  render: =>
    filters = @model.get('filters')?.toJSON() || []
    @$el.html @template({filters: filters})
    @

module.exports = FilterSettings