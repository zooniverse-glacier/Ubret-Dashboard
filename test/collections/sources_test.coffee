Sources = require 'collections/sources'

describe 'Sources', ->
  beforeEach ->
    @sources = new Sources

  it 'should be instantiable', ->
    expect(@settings).to.be.defined