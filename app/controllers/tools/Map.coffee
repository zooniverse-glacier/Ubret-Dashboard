Ubret = require 'ubret/lib'
DataSettings = require 'controllers/DataSettings'
MapSettings = require 'controllers/MapSettings'

class Map extends Ubret.Map
  
  settings: [DataSettings, MapSettings]
  
  constructor: ->
    super

  setFullscreenMode: =>
    @el.closest('.window-container').animate
      top: '25'
      left: ($(document).width() / 2) - (@el.width() / 2)
    @el.addClass 'fullscreen'
    @el.children('div').css
      position: 'fixed'
      top: 0
      left: 0
      width: '100%'
      height: '100%'
      z_index: '0'
    @map.invalidateSize true

module.exports = Map