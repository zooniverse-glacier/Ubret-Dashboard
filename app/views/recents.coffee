BaseView = require 'views/base_view'
Collection = require 'collections/recents'

class Recents extends BaseView
  className: 'my-data-recents'
  template: require './templates/recent_list'
  templateItem: require './templates/recent'
  
  initialize: ->
    @collection = new Collection
    @collection.on 'add reset', @render

  loadCollection: =>
    @collection.fetch().fail (args...) ->
      console.log args 

  render: =>
    @$el.html @template()
    if not @collection.isEmpty()
      @collection.each (model) =>
        @$('.recents').append @templateItem(model.toJSON())
    @


module.exports = Recents
