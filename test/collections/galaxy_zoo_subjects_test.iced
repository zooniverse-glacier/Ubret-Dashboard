GalaxyZooSubjects = require 'collections/galaxy_zoo_subjects'
GalaxyZooSubject = require 'models/galaxy_zoo_subject'

describe 'GalaxyZooSubjects', ->
  it 'should be defined', ->
    expect(GalaxyZooSubjects).to.be.ok

  it 'should be instantiable', ->
    gzSubjects = new GalaxyZooSubjects
    expect(gzSubjects).to.be.ok

  describe 'properties', ->
    beforeEach ->
      @gzSubject = new GalaxyZooSubjects

    it 'should have GalaxyZooSubject defined as its model', ->
      expect(@gzSubject).to.have.property('model').and.equal(GalaxyZooSubject)

    it 'should have a defualt set of params defined', ->
      expect(@gzSubject).to.have.property('params').and.to.have.property('limit', 10)

  describe '#url', -> 
    it 'should return url of the form /gz_subjects?(params)', ->
      gzSubject = new GalaxyZooSubjects
      expect(gzSubject.url()).to.equal("/gz_subjects?limit=10")

  describe '#processParams', ->
    it 'should convert hash to a string of the form param=setting', ->
      gzSubject = new GalaxyZooSubjects
      expect(gzSubject.processParams()).to.equal('limit=10')
