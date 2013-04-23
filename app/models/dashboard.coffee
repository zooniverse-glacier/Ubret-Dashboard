Manager = require 'modules/manager'

class Dashboard extends Backbone.AssociatedModel
  sync: require 'lib/ouroboros_sync'
  urlRoot: '/dashboards'
  user: require 'lib/user'

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
    url = if parseInt(location.port) < 1024 
      "https://dev.zooniverse.org" 
    else if parseInt(location.port) is 3333 
      "http://192.168.33.10"
    else
      "https://dev.zooniverse.org"
    url = "#{url}/projects/#{Manager.get('project')}/dashboards/#{@id}/fork"
    $.ajax url,
      type: 'POST'
      crossDomain: true
      dataType: 'json'
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'Authorization', 
          "Basic #{btoa("#{@user.current.name}:#{@user.current.apiToken}")}"

module.exports = Dashboard