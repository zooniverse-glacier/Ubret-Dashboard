class Toolbox extends Backbone.View
  _.extend @prototype, Backbone.Events

  tagName: 'div'
  className: 'toolbox'
  template: require './templates/toolbox'

  tools: [
    { name: 'Table', description: 'displays data in a tabular format' }
  ]

  events: 
    'click .tool-icon button' : 'createTool'
    'click button[name="remove-tools"]' : 'removeTools' 

  render: =>
    @$el.html @template {tools: @tools}
    @

  createTool: (e) =>
    toolType = $(e.currentTarget).attr('name')
    @trigger "create-#{toolType}"

  removeTools: (e) =>
    @trigger "remove-tools"

module.exports = Toolbox
