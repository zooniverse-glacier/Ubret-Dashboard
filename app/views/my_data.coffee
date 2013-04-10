BaseView = require 'views/base_view'

class MyData extends BaseView
  favoritesView: require 'views/favorites'
  recentsView: require 'views/recents'
  collectionsView: require 'views/collections'
  user: require 'lib/user'

  initialize: ->
    @recents = new @recentsView
    @favorites = new @favoritesView 
    @collections = new @collectionsView
    @user.on 'sign-out', @resetCollections

  loadCollections: =>
    @recents.loadCollection()
    @favorites.loadCollection()
    @collections.loadCollection()

  resetCollections: =>
    @recents.reset()
    @favorites.reset()
    @collections.reset()

  render: =>
    @$el.append @recents.render().el
    @$el.append @favorites.render().el
    @$el.append @collections.render().el
    @loadCollections()
    @

module.exports = MyData