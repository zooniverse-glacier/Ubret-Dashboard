BaseView = require 'views/base_view'

class MyData extends BaseView
  template: require './templates/my_data'
  manager: require 'modules/manager'
  projects: require 'config/projects_config'
  favoritesView: require 'views/favorites'
  recentsView: require 'views/recents'
  user: require 'lib/user'

  events: 
    'change #project-select' : 'updateManager'

  initialize: ->
    @recents = new @recentsView
    @favorites = new @favoritesView 
    @user.on 'sign-out', @resetCollections

  loadCollections: =>
    @recents.loadCollection()
    @favorites.loadCollection()

  resetCollections: =>
    @recents.reset()
    @favorites.reset()

  updateManager: (e) =>
    @manager.set 'project', e.currentTarget.value
    @render()

  render: =>
    @selected = @manager.get('project')
    @$el.html @template(@)
    @$el.append @recents.render().el
    @$el.append @favorites.render().el
    @loadCollections()
    @

module.exports = MyData