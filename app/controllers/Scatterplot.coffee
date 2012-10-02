UbretScatterplot = require 'ubret/lib/controllers/Scatterplot'
DataSettings = require 'controllers/DataSettings'
ScatterplotSettings = require 'controllers/ScatterplotSettings'

class Scatterplot extends UbretScatterplot
  constructor: ->
    super

  settings: [DataSettings, ScatterplotSettings]

module.exports = Scatterplot