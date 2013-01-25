BaseView = require 'views/base_view'
Favorites = require 'views/favorites'
Recents = require 'views/recents'
User = require 'user'

class MyData extends BaseView

  initialize: ->
    @recents = new Recents
    @favorites = new Favorites
    User.on 'sign-out', @resetCollections

  loadCollections: =>
    @recents.loadCollection()
    @favorites.loadCollection()

  resetCollections: =>
    @recents.resst()
    @favorites.reset()

  render: =>
    @$el.empty()
    @$el.append @recents.render().el
    @$el.append @favorites.render().el


module.exports = MyData