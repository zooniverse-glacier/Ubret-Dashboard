Manager = require 'modules/manager'
tools = require 'config/toolset_config'

ToolLoader = (dashboard, cb) ->
  project = dashboard.get('project')
  unless project and tools.projects.hasOwnProperty project
    project = 'default'

  Manager.set 'project', project
  
  # Set valid tools for later retrieval.
  # If project is Object, use tools key. If not, assume it's the array of tools.
  if (tools.projects[project] is Object(tools.projects[project])) and tools.projects[project].hasOwnProperty 'tools'
    Manager.set 'tools', tools.projects[project].tools
  else
    Manager.set 'tools', tools.projects[project]

  if location.port > 3332
    Ubret.Loader Manager.get('tools'), cb
  else
    Ubret.ToolsetLoader Manager.get('project'), cb

module.exports = ToolLoader
