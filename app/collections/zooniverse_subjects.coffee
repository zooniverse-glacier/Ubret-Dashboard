class ZooniverseSubjectCollection extends Backbone.Collection
  manager: require 'modules/manager'
  user: require 'lib/user'
  model: require 'models/subject'
  sync: require 'lib/ouroboros_sync'

  initialize: (models=[], options={}) ->
    @base = options.base
    @type = parseInt(options.search_type)

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
    else
      response

  url: =>
    if @type is 0 or @type is 3
      console.log 'here'
      @base(@id)
    else
      unless @user.current?
        throw new Error('Must be logged in to retrieve your recents or favorites')
      @base(@user.current.id) + '?' + @processParams()

  fetch: =>
    return super unless (@type is 1) or (@type is 3)
    collection = $.ajax @manager.api() + @url(),
      type: "GET"
      crossDomain: true
      dataType: 'json'
    collection.then @fetchSubjects

  fetchSubjects: (response) =>
    zooIDs = if _.isArray(response)
      _.map(response, (sub) -> sub.subjects[0].zooniverse_id)
    else
      _.map(response.subjects, (sub) -> sub.zooniverse_id)
    options = 
      url: @manager.api() + "/subjects/batch",
      type: "POST"
      crossDomain: true
      dataType: 'json'
      contentType: "application/json; charset=utf-8"
      data: JSON.stringify({subject_ids: zooIDs})
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
      .value()

  serengeti: (subject) =>
    {
      uid: subject.zooniverse_id
      image: subject.location.standard[0]
      thumb: subject.location.standard[0]
      latitude: subject.coords[0]
      longitutde: subject.coords[1]
      timestamp: subject.metadata.timestamps[0]
      animals: @snapshotAnimals(subject.metadata.counters)
    }

module.exports = ZooniverseSubjectCollection
