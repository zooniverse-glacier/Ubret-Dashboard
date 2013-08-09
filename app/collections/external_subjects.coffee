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
  
  parse: (d) ->
    if d.fields and d.fields.locations
      rows = _.map(d.rows, (d) ->
        d['uid'] = d.subject_id
        d['image'] = d.locations
        
        delete d[field] for field in ['subject_id', 'locations', 'cartodb_id', 'created_at', 'updated_at', 'the_geom', 'the_geom_webmercator', 'user_group_ids']
        d
      )
    else
      d

module.exports = ExternalSubjectCollection
