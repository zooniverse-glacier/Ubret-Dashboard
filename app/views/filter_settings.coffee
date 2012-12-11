BaseView = require 'views/base_view'

class FilterSettings extends BaseView
  tagName: 'div'
  className: 'filter-settings'
  template: require './templates/filter_settings'

  events: 
    'click button[name="filter"]' : 'addFilter'

  initialize: ->
    @model.get('filters')?.on 'add', @render

  addFilter: (e) =>
    key = @model.get('selectedKey') or 'id'
    extents = @model.dataSource.dataExtents key, @model.get('selectedElements')
    @model.get('filters').add
      key: key
      min: extents.min
      max: extents.max
      text: "#{key} from #{extents.min} to #{extents.max}"

  render: =>
    filters = @model.get('filters')?.toJSON() || []
    @$el.html @template({filters: filters})
    @

module.exports = FilterSettings