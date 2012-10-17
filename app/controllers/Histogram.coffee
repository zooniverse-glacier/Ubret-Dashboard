UbretHistogram = require 'ubret/lib/controllers/Histogram'
DataSettings = require 'controllers/DataSettings'
HistogramSettings = require 'controllers/HistogramSettings'

class Histogram extends UbretHistogram
  
  settings: [DataSettings, HistogramSettings]
  
  constructor: ->
    super


module.exports = Histogram