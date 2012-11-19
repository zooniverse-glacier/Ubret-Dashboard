UbretTool = require 'views/ubret_tool'

class ToolContainer extends Backbone.View
  tagName: 'div'
  className: 'tool-container'

  initialize: =>
    if @model?
      @createToolView()

  createToolView: =>
    if @model.has('type')
      @toolView = new UbretTool { model: @model, id: @model.get('channel') }

  render: =>
    @$el.html @toolView?.render().el
    @


module.exports = ToolContainer