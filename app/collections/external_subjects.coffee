Manager = require 'modules/manager'

class ExternalSubjectCollection extends Backbone.Collection
  model: require 'models/subject' 
  sync: require 'lib/endpoints_sync'

  initialize: (models=[], options={}) ->
    throw new Error('must provide a url') unless options.url

    @base = options.url
    @params = new Object

    if options.params? and options.params.length
      options.params.each (param) =>
        @params[param.get('key')] = param.get('val')

  url: =>
    @base + '?' + @processParams()

  comparator: (subject) ->
    subject.get('uid')

  processParams: =>
    params = new Array
    params.push "#{key}=#{value}" for key, value of @params
    "#{params.join('&')}&format=json"

module.exports = ExternalSubjectCollection
