class Toolbox extends Backbone.View
  _.extend @prototype, Backbone.Events

  tagName: 'div'
  className: 'toolbox'
  template: require './templates/toolbox'

  events: 
    'click .tool-icon button' : 'createTool'
    'click button[name="remove-tools"]' : 'removeTools' 

  render: =>
    tools = _.keys Ubret
    toolNames = new Array
    
    for tool in tools
      toolNames.push {name: tool} unless tool in ['BaseTool', 'Graph']
      
    @$el.html @template {tools: toolNames}
    @

  createTool: (e) =>
    toolType = $(e.currentTarget).attr('name')
    @trigger 'create', toolType

  removeTools: (e) =>
    @trigger "remove-tools"

module.exports = Toolbox
