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
    tools = _.map tools, (tool) ->
      tool = {name: tool}
    @$el.html @template {tools: tools}
    @

  createTool: (e) =>
    toolType = $(e.currentTarget).attr('name')
    @trigger 'create', toolType

  removeTools: (e) =>
    @trigger "remove-tools"

module.exports = Toolbox
