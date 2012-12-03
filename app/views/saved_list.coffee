class SavedList extends Backbone.View
  tagName: "ul"
  className: "saved-list"
  template: require './templates/saved_dashboard'

  initialize: ->
    Backbone.Mediator.subscribe 'new-dashboard', (dashboard) =>
      @collection.add dashboard

  render: =>
    @$el.append(@collection.each (dashboard) => 
      item =
        id: dashboard.id
        name: dashboard.name
      @template(item))
    @

module.exports = SavedList
