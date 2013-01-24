BaseView = require 'views/base_view'
Collection = require 'collections/recents'

class Recents extends BaseView
  className: 'my-data-recents'
  template: './templates/recent'
  
  initialize: ->
    @collection = new Collection
    @collection.on 'add reset', @render

  loadCollection: =>
    @collection.fetch()

  render: =>
    @$el.empty()
    if not @collection.isEmpty()
      @collection.each (model) ->
        @$el.append @template(model.toJSON())
    @


module.exports = Recents
