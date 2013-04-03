class ZooniverseSubjectCollection extends Backbone.Collection
  manager: require 'modules/manager'
  user: require 'lib/user'
  model: require 'models/subject'
  sync: require 'lib/ouroboros_sync'

  initialize: (models=[], options={}) ->
    @base = options.url
    @type = options.search_type

    if @type is 0
      @id = options.params.find((param) => param.get('key') is 'id').get('val')
    else if options.params? and options.params.length
      @params = new Object
      options.params.each (param) =>
        @params[param.get('key')] = param.get('val')

  parse: (response) ->
    if _.isFunction(@[@manager.get('project')])
      if _.isArray(response)
        _(response).chain()
          .map((sub) -> sub.subjects[0])
          .map(@[@manager.get('project')]).value()
      else
        _([response]).map(@[@manager.get('project')])
    else
      response

  url: =>
    if @type is 0
      @base(@id)
    else
      unless @user.current?
        throw new Error('Must be logged in to retrieve your recents or favorites')
      @base(@user.current.id) + '?' + @processParams()

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
