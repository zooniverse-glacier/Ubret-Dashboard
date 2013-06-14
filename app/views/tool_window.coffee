Window = require 'views/window'

class ToolWindow extends Window
  settingsView: require 'views/settings'
  toolConfig: require('config/tool_config')
  settingsView: require 'views/settings'

  initialize: ->
    super
    @settings = new @settingsView {model: @model}
    @locked = @toolConfig[@model.get('tool_type')].locked

  render: =>
    super
    @assign
      '.settings': @settings

    @$('.container').height(parseInt(@model.get('height')) - 25 )
      .addClass(@model.get('tool_type'))
      .html @model.tool.el
    @

  removeWindow: =>
    @settings.remove()
    super
  
module.exports = ToolWindow