UbretTool = require 'views/ubret_tool'

class ToolContainer extends Backbone.View
  tagName: 'div'
  className: 'tool-container'

  initialize: =>
    if @model?
      @createToolView()
      @model.on 'change:type', @updateTool
      @model.on 'change:height change:width', @setSize
      @setSize()

  createToolView: =>
    if @model.has('type')
      @toolView = new UbretTool { model: @model, id: @model.get('channel') }

  updateTool: =>
    @toolView.remove()
    @createToolView()

  setSize: =>
    @$el.css 'height', @model.get('height') - 20
    @$el.css 'width', @model.get('width') 

  render: =>
    @$el.html @toolView?.render().el
    @

module.exports = ToolContainer
