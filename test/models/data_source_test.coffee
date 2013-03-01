DataSource = require 'models/data_source'
Subjects = require 'collections/external_subjects'
Backbone = window.Backbone

describe 'DataSource', ->
  beforeEach ->
    @intDataSource = new DataSource { source_type: 'internal', source: 'table-1' }
    @intDataSource2 = new DataSource { source_type: 'internal', source: null }

    @extDataSource = new DataSource
      source_type: 'external'
      source: '1'
    @extDataSource.data = new Subjects [
      {field1: 'label', field2: 'value'}
      {field1: 77, field2: null}
      {field1: 'asdf sadf asd', field2: {key: 'here', val: 'and now'}}
    ], {url: '/tester'}

    # Broken sources
    @invalidDataSource = new DataSource {source_type: null, source: '1'}
    @invalidDataSource2 = new DataSource {source_type: 'cheers', source: '1'}

  describe '#fetchData', ->
    beforeEach ->
      @saveIntSpy = sinon.stub(@intDataSource, 'save')
      @saveExtSpy = sinon.stub(@extDataSource, 'save')

    it 'should call #fetchExt when data is external', ->
      spy = sinon.stub(@extDataSource, 'fetchExt')
      @extDataSource.fetchData()
      expect(spy).to.have.been.called

      @extDataSource.fetchExt.restore()

    it 'should call #fetchInt when data is internal', ->
      spy = sinon.stub(@intDataSource, 'fetchInt')
      @intDataSource.fetchData()
      expect(spy).to.have.been.called

      @intDataSource.fetchInt.restore()

    it 'should throw an error if source_type is neither external or internal', ->
      expect(@invalidDataSource.fetchData).to.throw()
      expect(@invalidDataSource2.fetchData).to.throw()

  describe '#fetchExt', ->
    # This one is harder.


  describe '#fetchInt', ->
    beforeEach ->
      @spy.reset()

    before ->
      @spy = sinon.stub(Backbone.Mediator, 'publish')

    after ->
      @spy.restore()

    it 'should fetch data from an internal source, when source is set', ->
      @intDataSource.fetchInt()
      expect(@spy).to.have.been.called

    it 'should not fetch data if no source is set', ->
      @intDataSource2.fetchInt()
      expect(@spy).to.not.have.been.called

  describe '#isExternal', ->
    it 'should return true if source_type is external', ->
      expect(@extDataSource.isExternal()).to.be.true
      expect(@intDataSource.isExternal()).to.be.false

  describe '#isInternal', ->
    it 'should return true if source_type is internal', ->
      expect(@extDataSource.isInternal()).to.be.false
      expect(@intDataSource.isInternal()).to.be.true

  describe '#isReady', ->
    it 'For an internal tool, returns true if source is defined', ->
      expect(@intDataSource.isReady()).to.be.true

    it 'For an external tool, returns true if data is defined and not empty', ->
      expect(@extDataSource.isReady()).to.be.true




