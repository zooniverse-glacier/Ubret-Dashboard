AppView = require 'views/app_view'

class Toolbox extends AppView
  tagName: 'div'
  className: 'toolbox'
  template: require './templates/toolbox'

  events: 
    'click .tool-icon button' : 'createTool'
    'click button[name="remove-tools"]' : 'removeTools' 

  initialize: ->
    @tools = []
    for name, tool of Ubret
      @tools.push {name: tool::name, class_name: name} if tool::name

  render: =>
    @$el.html @template {available_tools: @tools}
    @

  createTool: (e) =>
    toolType = $(e.currentTarget).attr('name')
    @trigger 'create', toolType

  removeTools: (e) =>
    @trigger "remove-tools"

module.exports = Toolbox
