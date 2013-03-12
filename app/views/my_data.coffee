BaseView = require 'views/base_view'
Favorites = require 'views/favorites'
Recents = require 'views/recents'
User = require 'lib/user'

class MyData extends BaseView
  template: require './templates/my_data'
  manager: require 'modules/manager'
  projects: require 'config/projects_config'

  events: 
    'change #project-select' : 'updateManager'

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