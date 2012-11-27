corsSync = require 'sync'
Subject = require 'models/subject'

class SubjectCollection extends Backbone.Collection
  model: Subject
  sync: corsSync

  initialize: (models=[], options={}) ->
    @base = options.url || '/etc'

    @params = new Object
    @params[key] = value for key, value of options.params when value isnt ''

  url: =>
    @base + '?' + @processParams()

  processParams: =>
    params = new Array
    params.push "#{key}=#{value}" for key, value of @params
    params.join '&'
    "#{params}&format=json"

module.exports = SubjectCollection
