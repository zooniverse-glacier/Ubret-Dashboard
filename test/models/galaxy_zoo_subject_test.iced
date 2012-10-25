GalaxyZooSubject = require 'models/galaxy_zoo_subject'

describe 'GalaxyZooSubject', ->
  it 'should be defined', ->
    expect(GalaxyZooSubject).to.be.ok

  it 'should be instantiable', ->
    galaxyZooSubject = new GalaxyZooSubject
    expect(galaxyZooSubject).to.be.ok
