class TalkCollections extends Backbone.Collection
  manager: require 'modules/manager'
  user: require 'lib/user'
  sync: require 'lib/ouroboros_sync'

  initialize: (models=[], options={}) ->
    @targetUser = options.user
    @page = options.page

  getPage: (page) =>
    @page = page
    @fetch()
    
  url: ->
    if @targetUser?
      url = "/talk/users/#{@targetuser}?type=my_collections"
    else
      url = "/talk/users/#{@user.current.name}?type=my_collections"
    url = url + "&page=#{@page}" if @page?
    url

  parse: (response) -> 
    response.my_collections

  formatModels: ->
    @map (i) -> 
      i[images] = _.map i.subjects, (s) -> s.location.standard[0]
      delete i.subjects
      i

module.exports = TalkCollections