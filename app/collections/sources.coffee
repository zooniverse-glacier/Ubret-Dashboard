class Sources extends Backbone.Collection

  sync: require 'sync'
  url: '/endpoints'

  initialize: ->
    @fetch()

  getSources: =>
    @map (source) ->
      'id': source.id
      'name': source.get('name')

module.exports = Sources