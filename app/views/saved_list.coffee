BaseView = require 'views/base_view'

class SavedList extends BaseView
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
