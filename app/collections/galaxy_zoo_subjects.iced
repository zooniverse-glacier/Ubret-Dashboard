GalaxyZooSubject = require 'models/galaxy_zoo_subject'

class GalaxyZooSubjects extends Backbone.Collection
  initialize: (models=[], options={}) ->
    @params[key] = value for key, value of options.params

  params:
    limit: 10

  model: GalaxyZooSubject

  url: =>
    "/gz_subjects?#{@processParams()}"

  processParams: =>
    params = new Array
    params.push "#{key}=#{value}" for key, value of @params
    params.join '&'


module.exports = GalaxyZooSubjects