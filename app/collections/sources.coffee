corsSync = require 'sync'

class Sources extends Backbone.Collection

  sync: corsSync
  url: '/endpoints'

  initialize: ->
    @fetch()

  getSources: =>
    @map (source) ->
      'id': source.id
      'name': source.get('name')

module.exports = Sources