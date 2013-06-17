Window = require 'views/window'

class ToolWindow extends Window
  toolConfig: require('config/tool_config')

  initialize: ->
    super
    @locked = @toolConfig[@model.get('tool_type')].locked

  render: =>
    super
    @$('.container').height(parseInt(@model.get('height')) - 25 )
      .addClass(@model.get('tool_type'))
      .html @model.tool.el
    @

  
module.exports = ToolWindow