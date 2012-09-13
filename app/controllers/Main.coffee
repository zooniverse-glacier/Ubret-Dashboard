Dashboard     = require('controllers/Dashboard')
Toolbox       = require('controllers/Toolbox')
Table         = require('ubret/lib/controllers/Table')
Map           = require('ubret/lib/controllers/Map')
Scatterplot   = require('ubret/lib/controllers/Scatterplot')
SubjectViewer = require('ubret/lib/controllers/SubjectViewer')
# Histogram     = require('ubret/lib/controllers/Histogram')

class Main extends Spine.Controller
  constructor: ->
    super
    @append require('views/main')()
    
    # Create dashboard
    @dashboard = new Dashboard({el: ".dashboard"})
    @dashboard.render()
    
    @toolbox = new Toolbox( {el: ".toolbox", tools: [ 
      {name: "Subject Viewer", desc: "Views Subjects"},
      {name: "Scatterplot", desc: "Plots things scatteredly"},
      {name: "Map", desc: "Maps Things"},
      {name: "Table", desc: "Tables Things"}
      # {name: "Histogram", desc: "Plots things historigrammically"}
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
      # when "Histogram" then @dashboard.createTool Histogram

  removeTools: =>
    @dashboard.removeTools()

module.exports = Main