BaseView = require 'views/base_view'
Favorites = require 'views/favorites'
Recents = require 'views/recents'

class MyData extends BaseView

  initialize: ->
    @recents = new Recents
    @favorites = new Favorites

  loadCollections: =>
    @recents.loadCollection()
    @favorites.loadCollection()

  render: =>
    @$el.empty()
    @$el.append @recents.render().el
    @$el.append @favorites.render().el


module.exports = MyData