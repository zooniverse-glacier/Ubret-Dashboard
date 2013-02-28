Manager = require 'modules/manager'
User = require 'lib/user'

class ZooniverseSubjectCollection extends Backbone.Collection
  model: require 'models/subject'
  sync: require 'lib/ouroboros_sync'

  parse: (response) ->
    if _.isFunction(@[Manager.get('project')])
      if _.isArray(response)
        _(response).chain()
          .map((sub) -> sub.subjects[0])
          .map(@[Manager.get('project')]).value()
      else
        _([response]).map(@[Manager.get('project')])
    else
      response

  initialize: (models=[], options={}) ->
    unless User.current?
      throw new Error('must be logged in to retrieve subjecst from Zooniverse') 

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
    for key, value of @params
      if key is 'limit'
        key = 'per_page'
      params.push "#{key}=#{value}" 
    params.join('&')

  galaxy_zoo: (subject) =>
    model = new Object
    model.uid = subject.zooniverse_id
    model.image = subject.location.standard
    model.thumb = subject.location.thumbnail
    model.ra = subject.coords[0]
    model.dec = subject.coords[1]
    model.absolute_size = subject.metadata.absolute_size
    if subject.metadata.mag?
      model[key] = value for key, value of subject.metadata.mag
    model.petrorad_50_r = subject.metadata.petrorad_50_r
    model.redshift = subject.metadata.redshift
    model.sdss_id = subject.metadata.sdss_id
    model

module.exports = ZooniverseSubjectCollection


