DataSource = require 'models/data_source'
Sources = require 'collections/sources'

describe 'DataSource', ->
  beforeEach ->
    @intDataSource = new DataSource { source_type: 'internal', source: 'table-1' }

    @extDataSource = new DataSource
      source_type: 'external'
      source: '2'

    @zooDataSource = new DataSource
      source_type: 'external'
      search_type: 1
      source: '1'

    # Broken sources
    @invalidDataSource = new DataSource {source_type: null, source: '1'}
    @invalidDataSource2 = new DataSource {source_type: 'cheers', source: '1'}

  describe '#data', ->
    it 'should return a new zooSubject for zoo data sources', ->
      @zooDataSource.manager.data =
        sources: new Sources
      expect(@zooDataSource.data()).to.be.an.instanceof(@zooDataSource.zooSubjects)

    it 'should return a new extSubject for ext data sources', ->
      @extDataSource.manager.data =
        sources: new Sources
      expect(@extDataSource.data()).to.be.an.instanceof(@extDataSource.extSubjects)

    it 'should throw an error if source_type is neither external or internal', ->
      expect(@invalidDataSource.data).to.throw()
      expect(@invalidDataSource2.data).to.throw()

  describe '#isZooniverse', ->
    it 'should return true is source is "1"', ->
      expect(@zooDataSource.isZooniverse()).to.be.true
      expect(@extDataSource.isZooniverse()).to.be.false
      expect(@intDataSource.isZooniverse()).to.be.false

  describe '#isExternal', ->
    it 'should return true if source_type is external', ->
      expect(@extDataSource.isExternal()).to.be.true
      expect(@zooDataSource.isExternal()).to.be.true
      expect(@intDataSource.isExternal()).to.be.false

  describe '#isInternal', ->
    it 'should return true if source_type is internal', ->
      expect(@zooDataSource.isInternal()).to.be.false
      expect(@extDataSource.isInternal()).to.be.false
      expect(@intDataSource.isInternal()).to.be.true

