GalaxyZooSubjects = require 'collections/galaxy_zoo_subjects'

class Recents extends GalaxyZooSubjects
  url: ->
    "/projects/galaxy_zoo/recents?per_page=#{@count}"

  initialize: ->
    @count = 10

module.exports = Recents