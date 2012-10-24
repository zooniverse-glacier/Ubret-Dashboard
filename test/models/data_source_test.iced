DataSource = require 'models/data_source'

describe 'DataSource', ->
  it 'should be defined', ->
    expect(DataSource).to.be.ok

  it 'should be instantiable', ->
    dataSource = new DataSource
    expect(dataSource).to.be.ok
