Manager = require 'modules/manager'
projects = require 'config/projects_config'

ToolLoader = (dashboard, cb) ->
  project = Manager.get('project')
  Manager.set 'tools', projects[project].tools

  if parseInt(location.port) > 3332
    Ubret.Loader Manager.get('tools'), cb 
  else
    Ubret.ToolsetLoader Manager.get('project'), cb

module.exports = ToolLoader
