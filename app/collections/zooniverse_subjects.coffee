class ZooniverseSubjectCollection extends Backbone.Collection
  manager: require 'modules/manager'
  user: require 'lib/user'
  model: require 'models/subject'
  sync: require 'lib/ouroboros_sync'

  initialize: (models=[], options={}) ->
    @zooIDs = options.zoo_ids
    @type = options.type
    @id = options.id

    if @type
      @base = @manager.get('sources')
        .endpoints.zooniverse.search_types[@type].url

    if @type is 'collection' and options.params?
      @id = options.params.find((param) => param.get('key') is 'id').get('val')
    else if options.params? and options.params.length
      @params = new Object
      options.params.each (param) =>
        @params[param.get('key')] = param.get('val')

  parse: (response) ->
    if response.type is "SubjectSet"
      response.subjects
    else if _.isFunction(@[@manager.get('project')])
      if _.isArray(response)
        _(response).chain()
          .map((sub) -> 
            if sub.zooniverse_id
              sub
            else
              sub.subjects[0])
          .map(@[@manager.get('project')]).value()
      else
        _([response]).map(@[@manager.get('project')])
    else if _.isArray(response)
      _.map response, (s) -> 
        if s.zooniverse_id
          s.uid = s.zooniverse_id
        else
          s.uid = s.subjects[0].zooniverse_id
        s
    else
      response

  url: =>
    if @type is 'collection'
      if @id is '' or @id is undefined 
        throw new Error('Must supply Collection id')
      @base(@id)
    else
      unless @user.current?
        throw new Error('Must be logged in to retrieve your recents or favorites')
      @base(@user.current.id) + '?' + @processParams()

  fetch: =>
    return super unless @zooIDs?
    @fetchSubjects()

  fetchSubjects: =>
    options = 
      url: @manager.api() + "/subjects/batch",
      type: "POST"
      crossDomain: true
      dataType: 'json'
      contentType: "application/json; charset=utf-8"
      data: JSON.stringify({subject_ids: @zooIDs})
      success: (resp) =>
        @set(@parse(resp), options)
        @trigger 'sync', @, resp, options

    @sync('read', @, options)

  processParams: =>
    params = new Array
    for key, value of @params
      if key is 'limit'
        key = 'per_page'
      params.push "#{key}=#{value}" 
    params.join('&')

  galaxy_zoo_starburst: (subject) =>
    @galaxy_zoo(subject)

  galaxy_zoo: (subject) =>
    model = 
      uid: subject.zooniverse_id
      image: subject.location.standard
      thumb: subject.location.thumbnail
      ra: subject.coords[0]
      dec: subject.coords[1]
      absolute_size: subject.metadata.absolute_size
      petrorad_50_r: subject.metadata.petrorad_50_r
      redshift: subject.metadata.redshift
      sdss_id: subject.metadata.sdss_id
    model[key] = subject.metadata.mag?[key] for key in ['u', 'g', 'r', 'i', 'z', 'abs_r']
    model

  snapshotAnimals: (counters) ->
    _(counters).chain().pairs()
      .filter((p) -> _.last(p) > 7.5)
      .map(_.first)
      .map((d) -> d.split('-'))
      .flatten()
      .value()

  serengeti: (subject) =>
    {
      uid: subject.zooniverse_id
      image: subject.location?.standard
      thumb: subject.location?.standard?[0]
      latitude: subject.coords?[0]
      longitutde: subject.coords?[1]
      timestamp: subject.metadata?.timestamps?[0]
      animals: @snapshotAnimals(subject.metadata.counters) if subject.metadata?.counters?
    }

module.exports = ZooniverseSubjectCollection
