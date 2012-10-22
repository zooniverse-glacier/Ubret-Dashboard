_ = require('underscore/underscore')

Dashboard     = require('controllers/Dashboard')
Toolbox       = require('controllers/Toolbox')

Ubret = require 'ubret/lib'
# Might be a cleaner way to do this. Or possibly in build?
extended_tools = {}
for tool in _.functions Ubret
  try
    Ubret[tool] = require 'controllers/tools/' + tool
  catch err

State = require 'controllers/state'

class Main extends Spine.Controller
  className: 'ubret'

  constructor: ->
    super
    @state = new State()
    Spine.bind 'save-state', @saveState

  active: (params) ->
    @setup()
    if typeof params.state is 'string' and params.state.length > 0
      # Load passed state
      @loadState params.state

  setup: =>
    @html require('views/main')()
    
    # Create dashboard
    @dashboard = new Dashboard({el: ".dashboard"})
    @dashboard.render()
    
    tools = _.keys Ubret
    tools = _.map tools, (tool) ->
      tool = {
          name: tool
        }
    @toolbox = new Toolbox({el: ".toolbox", tools: tools})

    @toolbox.render()
    @toolbox.bind 'add-new-tool', @addTool
    @toolbox.bind 'remove-all-tools', @removeTools

  addTool: (toolName) =>
    @dashboard.createTool Ubret[toolName]

  saveState: =>
    @state.save({dashboard: @dashboard})

  loadState: (params) =>
    @state.load({dashboard: @dashboard, state_id: params})

  removeTools: =>
    @dashboard.removeTools()

module.exports = Main
