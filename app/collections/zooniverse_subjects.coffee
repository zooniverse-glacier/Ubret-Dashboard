class ZooniverseSubjectCollection extends Backbone.Collection
  manager: require 'modules/manager'
  user: require 'lib/user'
  model: require 'models/subject'
  sync: require 'lib/ouroboros_sync'

  initialize: (models=[], options={}) ->
    @base = options.base
    @type = options.search_type

    if @type is 0 or @type is 3
      @id = options.params.find((param) => param.get('key') is 'id').get('val')
    else if options.params? and options.params.length
      @params = new Object
      options.params.each (param) =>
        @params[param.get('key')] = param.get('val')

  parse: (response) ->
    if response.type is "SubjectSet"
      response = response.subjects
    if _.isFunction(@[@manager.get('project')])
      console.log 'herea'
      if _.isArray(response)
        console.log 'here'
        _(response).chain()
          .map((sub) -> console.log sub; sub.subjects[0])
          .map(@[@manager.get('project')]).value()
      else
        _([response]).map(@[@manager.get('project')])
    else
      response

  url: =>
    if @type is 0 or @type is 3
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
    console.log subject
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
