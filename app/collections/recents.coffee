GalaxyZooSubjects = require 'collections/galaxy_zoo_subjects'
User = require 'user'

class Recents extends GalaxyZooSubjects
  url: ->
    "/projects/galaxy_zoo/users/#{User.current.id}/recents?per_page=#{@count}"

  initialize: ->
    @count = 10

module.exports = Recents