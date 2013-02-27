Manager = require 'modules/manager'
User = require 'lib/user'

class ZooniverseSubjectCollection extends Backbone.Collection
  model: require 'models/subject'
  sync: require 'lib/ouroboros_sync'

  initialize: (models=[], options={}) ->
    unless User.current?
      throw new Error('must be logged in to retrieve subjecst from Zooniverse') 

    console.log options

    @base = options.url
    @type = options.search_type
    @params = new Object

    if @type is 0
      @id = options.params.find((param) => param.get('key') is 'id').get('val')
    else if options.params? and options.params.length
      options.params.each (param) =>
        @params[param.get('key')] = param.get('val')

  url: =>
    if @type is 0
      @base(@id)
    else
      @base(User.current.id) + '?' + @processParams()

  processParams: =>
    params = new Array
    params.push "#{key}=#{value}" for key, value of @params
    params.join('&')

module.exports = ZooniverseSubjectCollection


