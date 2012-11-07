Filter = require 'models/filter'

describe 'filter', ->
  it 'should be defined', ->
    expect(Filter).to.be.ok

  it 'should be instantiable', ->
    filter = new Filter
    expect(filter).to.be.ok
