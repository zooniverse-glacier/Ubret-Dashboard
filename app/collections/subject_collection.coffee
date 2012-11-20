corsSync = require 'sync'

class SubjectCollection extends Backbone.Collection
  initialize: (models=[], options={}) ->
    @params = new Object
    @params[key] = value for key, value of options.params when value isnt ''

  sync: corsSync

  processParams: =>
    params = new Array
    params.push "#{key}=#{value}" for key, value of @params
    params.join '&'
    "#{params}&format=json"

module.exports = SubjectCollection
