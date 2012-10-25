Ubret = require 'ubret/lib'
DataSettings = require 'controllers/DataSettings'
MapSettings = require 'controllers/MapSettings'

class Map extends Ubret.Map
  
  settings: [DataSettings, MapSettings]
  
  constructor: ->
    super


module.exports = Map