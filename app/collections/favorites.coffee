GalaxyZooSubjects = require 'collections/galaxy_zoo_subjects'
User = require 'user'


class Favorites extends GalaxyZooSubjects
  url: ->
    "/projects/galaxy_zoo/users/#{User.current.id}/favorites?per_page=#{@count}"

  initialize: ->
    @count = 10

module.exports = Favorites
