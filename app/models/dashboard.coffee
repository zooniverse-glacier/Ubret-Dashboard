Manager = require 'modules/manager'
Sources = require 'collections/sources'

class Dashboard extends Backbone.AssociatedModel
  sync: require 'lib/ouroboros_sync'
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
    @once 'sync', => Manager.set 'dashboardId', @id
    @on 'add:tools', (tool) => tool.save()
    super

  createTool: (type) =>
    @get('tools').add
      tool_type: type

  fork: =>
    url = if location.port < 1024 then "https://spelunker.herokuapp.com" else "http://localhost:3000"
    url = "#{url}#{@urlRoot}/#{@id}/fork"
    $.ajax url,
      type: 'POST'
      crossDomain: true
      dataType: 'json'
      xhrFields:
        withCredentials: true

module.exports = Dashboard