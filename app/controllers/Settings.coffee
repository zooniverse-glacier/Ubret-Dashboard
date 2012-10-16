Spine = require('spine')
DataSettings = require('controllers/DataSettings')

class Settings extends Spine.Controller
  className: 'settings'
  
  constructor: ->
    super
    @settings = new Array
    if @toolSettings.length isnt 0
      for setting in @toolSettings
        @settings.push(new setting {tool: @tool})
    else
      @settings.push(new DataSettings {tool: @tool})

  render: =>
    for setting in @settings
      setting.render()
      @append setting.el 

module.exports = Settings