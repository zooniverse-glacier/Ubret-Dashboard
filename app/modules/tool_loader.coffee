Manager = require 'modules/manager'

ToolLoader = (dashboard, cb) ->
  $.getJSON '/tools.json', (tools) =>
    ###
    Long-form way of checking if scripts are loaded.
    Also not really the location I want to put this in the end.
    ###
    isScriptNotLoaded = (script) ->
      if _.isUndefined window[script.name]
        # Not on window. Maybe an Ubret script.
        if _.isUndefined Ubret[script.name]
          return true
      return false

    project = dashboard.get('project')
    unless project and tools.projects.hasOwnProperty project
      project = 'default'

    # Set current project.
    Manager.set 'project', project
    
    # Set valid tools for later retrieval.
    # If project is Object, use tools key. If not, assume it's the array of tools.
    if (tools.projects[project] is Object(tools.projects[project])) and tools.projects[project].hasOwnProperty 'tools'
      Manager.set 'tools', tools.projects[project].tools
    else
      Manager.set 'tools', tools.projects[project]

    # A highly inefficient way of resolving dependencies.
    # Not recursive yet either (dependency cannot have a dependency).
    tempScripts = []
    for tool in Manager.get 'tools'
      # Does tool have any dependencies
      if tools.scripts[tool].hasOwnProperty 'dependencies'
        # Add dependency to loading array
        for dependency in tools.scripts[tool].dependencies
          tempScripts.push
            name: dependency
            source: tools.scripts[dependency].source
      # Add script as well.
      tempScripts.push
        name: tool
        source: tools.scripts[tool].source

    uniqueScripts = _.uniq tempScripts, (script) -> script.name
    funcList = []
    for script in uniqueScripts
      do (script) ->
        funcList.push (cb) ->
          yepnope
            test: isScriptNotLoaded script
            yep: script.source
            complete: -> cb null, true

    async.parallel funcList, (err, results) =>
      if err
        console.log 'Error loading tools.', err
        return
      else
        cb()

module.exports = ToolLoader
