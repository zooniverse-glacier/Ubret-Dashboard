Spine = require 'spine'
_ = require 'underscore/underscore'

Ubret = require 'ubret/lib'
# Might be a cleaner way to do this. Or possibly in build?
extended_tools = {}
for tool in _.functions Ubret
  try
    Ubret[tool] = require 'controllers/tools/' + tool
  catch err

class State extends Spine.Controller

  constructor: ->
    super

  save: (params) =>
    state = new Object()
    dashboard = params.dashboard
    console.log 'DB:', dashboard

    tools = []
    for tool in dashboard.tools
      pos = @getOffset tool
      z_index = @getZIndex tool
      settings_toggle = @getSettingsToggle tool
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
          z_index: z_index
          settings_toggle: settings_toggle
        }
      tools.push obj

    state = {
        tools: tools
      }

    $.post 'http://localhost:9295/state', {state: JSON.stringify(state)}, (data) ->
      console.log 'id: ', data.id, 'state:', JSON.parse(data.state)

  load: (params) =>
    @trigger 'remove-all-tools'

    console.log 'loading state...'
    $.get "http://localhost:9295/state/#{params.state_id}", (data) ->
      data = JSON.parse data.state
      console.log 'state: ', data

      new_tools = []

      # Reset z-index to 0
      lowest_z_index = (_.min data.tools, (tool) -> tool.z_index).z_index
      _.each data.tools, (tool) -> tool.z_index -= lowest_z_index

      # Build initial state
      for tool in data.tools
        options =
          className: tool.className
          index: tool.index
          channel: tool.channel
          filters: tool.filters

        new_tool = params.dashboard.createTool Ubret[tool.name], options

        new_tool.data = tool.data
        new_tool.setBindOptions tool.bind_options.source, tool.bind_options.params

        toolWindow = new_tool.el.closest('.window-container')
        toolWindow.offset tool.pos
        toolWindow.css 'z-index', tool.z_index
        unless new_tool.settings_toggle
          toolWindow.find(".settings").removeClass('active')

        new_tools.push new_tool

      # Because some things may depend on all tools being available, run through the tools again to set setttings and the like.
      # Likely better ways to do this.
      for new_tool in new_tools
        if _.isUndefined new_tool.bindOptions.params
          new_tool.subscribe new_tool.bindOptions.source, new_tool.bindOptions.process
        else
          new_tool.setBindOptions new_tool.bindOptions.source, new_tool.bindOptions.params
          new_tool.receiveData new_tool.data

        # Set settings
        toolWindow = new_tool.el.closest('.window-container')
        toolWindow.find(".data-sources [data-source=#{new_tool.bindOptions.type}]").click()
        toolWindow.find(".source-choices").val(new_tool.bindOptions.source)
        toolWindow.find(".data-points input[name=params]").val(new_tool.bindOptions.params)

  # Helpers
  getOffset: (tool) ->
    toolWindow = tool.el.closest('.window-container')
    toolWindow.offset()

  getZIndex: (tool) ->
    toolWindow = tool.el.closest('.window-container')
    z_index = if toolWindow.css('z-index') is 'auto' then 0 else parseInt(toolWindow.css('z-index'))

  getSettingsToggle: (tool) ->
    toolWindow = tool.el.closest('.window-container')
    if toolWindow.find('.settings').hasClass('active') then true else false
    

module.exports = State