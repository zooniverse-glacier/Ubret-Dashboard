corsSync = require 'sync'
Manager = require 'modules/manager'
Sources = require 'collections/sources'
User = require 'user'

class Dashboard extends Backbone.AssociatedModel
  sync: corsSync
  urlRoot: '/dashboards'

  relations: [
    type: Backbone.Many
    key: 'tools'
    relatedModel: require('models/tool')
    collectionType: require('collections/tools')
  ]

  defaults:
    tools: []

  initialize: ->
    @set 'project', Manager.get 'project'

  createTool: (toolType) =>
    @get('tools').add
      type: toolType

module.exports = Dashboard