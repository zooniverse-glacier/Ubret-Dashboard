class FilterSettings extends Backbone.View
  tagName: 'div'
  className: 'filter-settings'
  template: require './templates/filter_settings'

  events: 
    'click button[name="filter"]' : 'addFilter'

  initialize: ->
    @collection?.on 'add', @render

  addFilter: (e) =>
    @collection.fromString @$(e.currentTarget).val()

  render: =>
    filters = @collection?.toJSON || []
    @$el.html @template({filters: filters})
    @

module.exports = FilterSettings