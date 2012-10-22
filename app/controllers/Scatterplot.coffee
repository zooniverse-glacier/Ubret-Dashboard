Ubret = require 'ubret/lib'
DataSettings = require 'controllers/DataSettings'
ScatterplotSettings = require 'controllers/ScatterplotSettings'

class Scatterplot extends Ubret.Scatterplot
  constructor: ->
    super

  settings: [DataSettings, ScatterplotSettings]

module.exports = Scatterplot