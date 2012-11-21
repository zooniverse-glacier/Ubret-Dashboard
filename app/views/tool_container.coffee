UbretTool = require 'views/ubret_tool'

class ToolContainer extends Backbone.View
  tagName: 'div'
  className: 'tool-container'

  initialize: =>
    unless @model then throw 'must pass a model'
    @toolView = new UbretTool {model: @model, id: @model.get('channel')}

  render: =>
    @$el.html @toolView.render().el
    @


module.exports = ToolContainer