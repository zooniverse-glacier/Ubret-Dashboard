_ = require('underscore/underscore')
ToolWindow = require('controllers/ToolWindow')

class Dashboard extends Spine.Controller
  constructor: ->
    super

  elements:
    '.tools': 'workspace'

  tools: []
  channels: []
  sources: ["GalaxyZooSubject", "SkyServerSubject"]
  count: 0

  render: =>
    @html require('views/dashboard')()

  addTool: (tool) ->
    @tools.push tool
    @channels.push tool.channel
    @createWindow(tool)

  createTool: (className, options = {}) ->
    @count += 1
    name = className.name.toLowerCase()

    tool_params =
      className: "#{name} tool" 
      index: @count
      channel: "#{name}-#{@count}"
      sources: @sources
      channels: @channels

    tool_options = _.defaults options, tool_params
    console.log tool_options

    tool = new className tool_options

    @addTool tool
    tool.bind "subscribed", (source) =>
      sourceTool = _.find @tools, (sTool) ->
        sTool.channel == source
      tool.receiveData sourceTool.filteredData

  createWindow: (tool) ->
    window = new ToolWindow {tool: tool, count: @count}
    window.render()
    window.window.toggleClass 'settings-active'
    @workspace.append window.el
    window.bind 'remove-tool', @removeTool

  removeTool: (tool) =>
    @tools = _.without @tools, tool
    @channels = _.without @channels, tool.channel

  removeTools: =>
    _.each @tools, @removeTool
    @workspace.html ''


module.exports = Dashboard