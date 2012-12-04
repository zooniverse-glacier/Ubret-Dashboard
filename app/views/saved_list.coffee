class SavedList extends Backbone.View
  tagName: "ul"
  className: "saved-list"
  template: require './templates/saved_dashboard'

  initialize: ->
    @collection.on 'add reset', @render

  render: =>
    @$el.append(@collection.each (dashboard) => 
      item =
        id: dashboard.id
        name: dashboard.name
      @template(item))
    @

module.exports = SavedList
