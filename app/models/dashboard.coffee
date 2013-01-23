Manager = require 'modules/manager'
Sources = require 'collections/sources'
User = require 'user'

class Dashboard extends Backbone.AssociatedModel
  sync: require 'sync'
  urlRoot: '/dashboards'

  relations: [
    type: Backbone.Many
    key: 'tools'
    relatedModel: require 'models/tool'
    collectionType: require 'collections/tools'
  ]

  defaults:
    tools: []
    name: "My Great Dashboard"
    project: "default"

  initialize: ->
    if Manager.get 'project' then @set 'project', Manager.get 'project'
    @once 'sync', => @get('tools').dashboardId = @id

  createTool: (type) =>
    @get('tools').add
      type: type

module.exports = Dashboard