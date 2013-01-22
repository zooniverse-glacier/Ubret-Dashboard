class SubjectCollection extends Backbone.Collection
  model: require 'models/subject' 
  sync: require 'sync'

  initialize: (models=[], options={}) ->
    @base = options.url || '/etc'

    @params = new Object
    options.params.each (param) =>
      @params[param.get('key')] = param.get('value')

  url: =>
    @base + '?' + @processParams()

  comparator: (subject) ->
    subject.get('uid')

  processParams: =>
    params = new Array
    params.push "#{key}=#{value}" for key, value of @params
    "#{params.join('&')}&format=json"

  next: (uid) =>
    if typeof @curIndex is 'undefined' or @at(@curIndex).get('uid') isnt uid
      @getCurrentSubject uid 
    @curIndex = @curIndex + 1
    @curIndex = 0 if @curIndex is @length
    @at(@curIndex).get('uid')

  previous: (uid) =>
    if typeof @curIndex is 'undefined' or @at(@curIndex).get('uid') isnt uid
      @getCurrentSubject uid 
    @curIndex = @curIndex - 1
    @curIndex = @length - 1 if @curIndex < 0
    @at(@curIndex).get('uid')

  getCurrentSubject: (uid) =>
    curSubject = @filter (subject) -> 
      subject.get('uid') is uid
    @curIndex = @indexOf(curSubject[0])

module.exports = SubjectCollection
