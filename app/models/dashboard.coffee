Manager = require 'modules/manager'
Sources = require 'collections/sources'
User = require 'user'

class Dashboard extends Backbone.AssociatedModel
  sync: require 'sync'
  urlRoot: '/dashboards'

  relations: [
    type: Backbone.Many
    key: 'tools'
    relatedModel: require('models/tool')
    collectionType: require('collections/tools')
  ]

  defaults:
    tools: []
    name: "My Great Dashboard"
    project: "default"

  initialize: ->
    console.log Manager.get 'project'
    if Manager.get 'project' then @set 'project', Manager.get 'project'

  createTool: (toolType) =>
    @get('tools').add
      type: toolType

module.exports = Dashboard