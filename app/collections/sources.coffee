class Sources extends Backbone.Collection
  initialize: ->
    @add require('config/endpoints_config')

  getSources: =>
    @map (source) ->
      'id': source.id
      'name': source.get('name')

module.exports = Sources