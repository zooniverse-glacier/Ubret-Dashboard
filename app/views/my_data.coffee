BaseView = require 'views/base_view'

class MyData extends BaseView
  favoritesView: require 'views/favorites'
  recentsView: require 'views/recents'
  collectionsView: require 'views/collections'
  user: require 'lib/user'
  template: require './templates/my_data'

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
    @$el.html @template()
    @$('.my-data-page').height window.innerHeight - 200
    @assign
      ".recents": @recents
      ".favorites": @favorites
      ".collections": @collections
    @loadCollections()
    @

module.exports = MyData