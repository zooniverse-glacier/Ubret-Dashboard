Spine = require 'spine'

class MapSettings extends Spine.Controller

  constructor: ->
    super

  events:
    'click .fullscreen' : 'setFullscreen'

  template: require 'views/map_settings'

  render: =>
    @html @template(@)

  setFullscreen: (e) =>
    @tool.setFullscreenMode $(e.currentTarget).val()

module.exports = MapSettings