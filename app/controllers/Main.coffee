Dashboard     = require('controllers/Dashboard')
Toolbox       = require('controllers/Toolbox')

Table = require('ubret/lib/controllers/Table')
Map = require('ubret/lib/controllers/Map')
Scatterplot = require('controllers/Scatterplot')
SubjectViewer = require('ubret/lib/controllers/SubjectViewer')
Histogram     = require('controllers/Histogram')
Statistics    = require('ubret/lib/controllers/Statistics')
WWT           = require('ubret/lib/controllers/WWT')
Spectra       = require('ubret/lib/controllers/Spectra')

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
      when "Map" then @dashboard.createTool Map
      when "Table" then @dashboard.createTool Table
      when "Scatterplot" then @dashboard.createTool Scatterplot
      when "Subject Viewer" then @dashboard.createTool SubjectViewer
      when "Histogram" then @dashboard.createTool Histogram
      when "Statistics" then @dashboard.createTool Statistics
      when "WWT" then @dashboard.createTool WWT
      when "Spectra" then @dashboard.createTool Spectra

  saveState: =>
    @state.save({dashboard: @dashboard})

  loadState: (params) =>
    @state.load({dashboard: @dashboard, state_id: params})

  removeTools: =>
    @dashboard.removeTools()

module.exports = Main
