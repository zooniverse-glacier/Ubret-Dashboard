BaseView = require 'views/base_view'
Favourites = require 'views/favourites'
Recents = require 'views/recents'

class MyData extends BaseView

  initialize: ->
    @recents = new Recents

  loadCollections: =>
    @recents.loadCollection()

  render: =>
    @$el.empty()
    @$el.append @recents.render().el


module.exports = MyData