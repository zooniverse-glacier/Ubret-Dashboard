Filters = require 'collections/filters'
Filter = require 'models/filter'

describe 'Filters', ->
  it 'should be defined', -> 
    expect(Filters).to.be.ok

  it 'should be instantiable', ->
    filters = new Filters
    expect(filters).to.be.ok

  describe 'properties', ->
    beforeEach ->
      @filters = new Filters

    it 'should have Filter as it\'s model', ->
      expect(@filters).to.have.property('model').and.equal(Filter)

  describe '#fromString', ->
