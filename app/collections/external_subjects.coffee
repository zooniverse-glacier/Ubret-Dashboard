Manager = require 'modules/manager'

class ExternalSubjectCollection extends Backbone.Collection
  model: require 'models/subject' 
  sync: require 'lib/endpoints_sync'

  initialize: (models=[], options={}) ->
    throw new Error('must provide a url') unless options.base 
    
    @base = options.base
    @urlBuilder = options.builder
    @params = {}
    
    if options.params? and options.params.length
      options.params.each (param) =>
        @params[param.get('key')] = param.get('val')

  url: =>
    if @urlBuilder?
      @base + "?q=#{@urlBuilder(@params)}"
    else
      @base + '?' + @processParams()

  comparator: (subject) ->
    subject.get('uid')

  processParams: =>
    params = new Array
    for key, value of @params when value isnt ''
      value = value.split('\n').join(' ') if key is 'query'
      params.push "#{key}=#{value}" 
    params.join("&")

module.exports = ExternalSubjectCollection
