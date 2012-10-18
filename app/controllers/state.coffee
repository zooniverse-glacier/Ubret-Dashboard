Spine = require 'spine'
_ = require 'underscore/underscore'

# Also wrong
Table = require('ubret/lib/controllers/Table')
Map = require('ubret/lib/controllers/Map')
Scatterplot = require('controllers/Scatterplot')
SubjectViewer = require('ubret/lib/controllers/SubjectViewer')
Histogram = require('controllers/Histogram')
Statistics = require('ubret/lib/controllers/Statistics')
WWT = require('ubret/lib/controllers/WWT')

class State extends Spine.Controller

  constructor: ->
    super

  save: (params) =>
    state = new Object()
    dashboard = params.dashboard
    console.log 'DB:', dashboard

    tools = []
    for tool in dashboard.tools
      pos = tool.el.offset()
      z_index = @getZIndex tool
      obj = {
          name: tool.name
          className: tool.className
          channel: tool.channel
          sources: tool.sources
          data: tool.data
          bind_options: tool.bindOptions
          filters: tool.filters
          binding: tool.bindOptions
          index: tool.count
          pos: pos
          z_index: parseInt(z_index)
        }

      tools.push obj

    state = {
        'tools': tools
      }

    $.post 'http://localhost:3001/state', {state: JSON.stringify(state)}, (data) ->
      console.log 'state saved', data

  load: (params) =>
    @trigger 'remove-all-tools'

    console.log 'loading state...'
    $.get "http://localhost:3001/state/#{params.state_id}", (data) ->
      data = JSON.parse data.state
      console.log 'state: ', data

      # Build initial state
      for tool in data.tools
        options =
          className: tool.className
          index: tool.index
          channel: tool.channel
          filters: tool.filters

        # I don't like this
        switch tool.name
          when "Map" then new_tool = params.dashboard.createTool Map, options
          when "Table" then new_tool = params.dashboard.createTool Table, options
          when "Scatterplot" then new_tool = params.dashboard.createTool Scatterplot, options
          when "Subject Viewer" then new_tool = params.dashboard.createTool SubjectViewer, options
          when "Histogram" then new_tool = params.dashboard.createTool Histogram, options
          when "Statistics" then new_tool = params.dashboard.createTool Statistics, options
          when "WWT" then new_tool = params.dashboard.createTool WWT, options

        console.log 'NT: ', new_tool

        if _.isUndefined tool.bind_options.params
          new_tool.bindTool tool.bind_options.source, tool.bind_options.process
        else
          new_tool.bindTool tool.bind_options.source, tool.bind_options.params

        toolWindow = new_tool.el.closest('.window-container')
        toolWindow.offset tool.pos
        toolWindow.css 'z-index', tool.z_index

        # Set settings
        toolWindow.find(".data-sources [data-source=#{new_tool.bindOptions.type}]").click()
        toolWindow.find(".source-choices").val(new_tool.bindOptions.source)
        toolWindow.find(".data-points input[name=params]").val(new_tool.bindOptions.params)

  # Helpers
  getZIndex: (tool) ->
    z_index = if _.isNaN(parseInt(tool.el.css('z-index'))) then 0 else tool.el.css('z-index')
    

module.exports = State