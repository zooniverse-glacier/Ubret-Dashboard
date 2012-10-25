Ubret = require 'ubret/lib'
DataSettings = require 'controllers/DataSettings'
HistogramSettings = require 'controllers/HistogramSettings'

class Histogram extends Ubret.Histogram
  
  settings: [DataSettings, HistogramSettings]
  
  constructor: ->
    super
    @width = 400
    @height = 300
    @binNumber = 10


module.exports = Histogram