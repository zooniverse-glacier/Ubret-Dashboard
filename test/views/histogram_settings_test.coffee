Histogram = require 'views/histogram_settings'

describe 'Histogram', ->
  it 'should be defined', ->
    expect(Histogram).to.be.ok

  it 'should be instantiable', ->
    histogram = new Histogram
    expect(histogram).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @histogram = new Histogram

    it 'should use a div as its tag', ->
      expect(@histogram.el.nodeName).to.be('DIV')

    it 'should have a class histogram-settings', ->
      expect(@histogram.$el).to.have.class('histogram-settings')
