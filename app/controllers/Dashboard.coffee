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

  createTool: (toolInstance, options = {}) ->
    @count += 1
    name = toolInstance.name.toLowerCase()

    unless options.length
      options = 
        className: "#{name} tool" 
        index: @count
        channel: "#{name}-#{@count}"
        sources: @sources
        channels: @channels

    tool = new toolInstance options

    @addTool tool
    tool.bind "subscribed", (source) =>
      sourceTool = _.find @tools, (sTool) ->
        sTool.channel == source
      tool.receiveData sourceTool.filteredData

    tool

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