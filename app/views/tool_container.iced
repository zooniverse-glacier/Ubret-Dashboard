class ToolContainer extends Backbone.View
  tagName: 'div'
  className: 'tool-container'

  toolTypes: 
    'table' : 'views/table'

  initialize: =>
    if @model?
      @createToolView()
      @model.on 'change', @updateTool()

  createToolView: =>
    tool = (require @toolTypes[@model.get('type')]) 
    @toolView = new tool { model: @model }

  updateTool: =>
    if @model.hasChanged('type')
      @toolView.remove()
      @createToolView()

   render: =>
     @$el.html @toolView?.render().el
     @

module.exports = ToolContainer
