Ubret = require 'ubret/lib'
DataSettings = require 'controllers/DataSettings'
HistogramSettings = require 'controllers/HistogramSettings'

class Histogram extends Ubret.Histogram
  
  settings: [DataSettings, HistogramSettings]
  
  constructor: ->
    super


module.exports = Histogram