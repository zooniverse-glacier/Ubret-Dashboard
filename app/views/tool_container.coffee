BaseView = require 'views/base_view'

UbretTool = require 'views/ubret_tool'

class ToolContainer extends BaseView
  tagName: 'div'
  className: 'tool-container'

  initialize: =>
    unless @model then throw 'must pass a model'
    @toolView = new UbretTool {model: @model, id: @model.get('channel')}

  render: =>
    @$el.html @toolView.render().el
    @

  update: =>
    @toolView.tool?.start() unless typeof @model.dataSource.get('data') is 'undefined'


module.exports = ToolContainer