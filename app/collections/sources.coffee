class Sources
  manager: require('modules/manager')
  config: require('config/projects_config')
  endpoints : require('config/endpoints_config')

  inProject: (source) =>
    project = @manager.get('project')
    sources = @config[project].sources
    source.name in sources

  at: (id) ->
    id = parseInt(id)
    (x) -> 
      x.id is id 

  get: (id) =>
    @endpoints[id]

  getSources: =>
    _(@endpoints).chain().filter(@inProject)
      .map((source) ->
        'id': source.id
        'name': source.name)
      .value()

module.exports = Sources