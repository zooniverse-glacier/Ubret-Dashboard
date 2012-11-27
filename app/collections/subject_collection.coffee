corsSync = require 'sync'
Subject = require 'models/subject'

class SubjectCollection extends Backbone.Collection
  model: Subject
  sync: corsSync

  initialize: (models=[], options={}) ->
    @base = options.url || '/etc'

    @params = new Object
    options.params.each (param) =>
      @params[param.get('key')] = param.get('value')

  url: =>
    @base + '?' + @processParams()

  processParams: =>
    params = new Array
    params.push "#{key}=#{value}" for key, value of @params
    params.join '&'
    "#{params}&format=json"

module.exports = SubjectCollection
