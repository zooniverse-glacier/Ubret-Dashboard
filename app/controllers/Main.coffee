_ = require('underscore/underscore')

Dashboard     = require('controllers/Dashboard')
Toolbox       = require('controllers/Toolbox')

Ubret = require 'ubret/lib'

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
    
    @toolbox = new Toolbox( {el: ".toolbox", tools: [ 
      {name: "Subject Viewer", desc: "Views Subjects"},
      {name: "Scatterplot", desc: "Plots things scatteredly"},
      {name: "Map", desc: "Maps Things"},
      {name: "Table", desc: "Tables Things"}
      {name: "Histogram", desc: "Plots things historigrammically"},
      {name: "Statistics", desc: "Make statistics appear"},
      {name: "WWT", desc: "Map with Worldwide Telescope"},
      {name: "Spectra", desc: "Visualize spectra from api.sdss3.org"}
    ]} )

    @toolbox.render()
    @toolbox.bind 'add-new-tool', @addTool
    @toolbox.bind 'remove-all-tools', @removeTools

  addTool: (toolName) =>
    switch toolName
      when "Table" then @dashboard.createTool Ubret.Table
      when "Map" then @dashboard.createTool Ubret.Map
      when "Scatterplot" then @dashboard.createTool Ubret.Scatterplot
      when "Subject Viewer" then @dashboard.createTool Ubret.SubjectViewer
      when "Histogram" then @dashboard.createTool Ubret.Histogram
      when "Statistics" then @dashboard.createTool Ubret.Statistics
      when "WWT" then @dashboard.createTool Ubret.WWT
      when "Spectra" then @dashboard.createTool Ubret.Spectra

  saveState: =>
    @state.save({dashboard: @dashboard})

  loadState: (params) =>
    @state.load({dashboard: @dashboard, state_id: params})

  removeTools: =>
    @dashboard.removeTools()

module.exports = Main
