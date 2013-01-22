DataSource = require 'models/data_source'

describe 'DataSource', ->
  beforeEach ->
    @intDataSource = new DataSource { type: 'internal', source: 'table-1' }
    @extDataSource = new DataSource { type: 'external', source: '1' }

  describe '#fetchData', ->
    beforeEach ->
      @saveIntSpy = sinon.stub(@intDataSource, 'save')
      @saveExtSpy = sinon.stub(@extDataSource, 'save')

    it 'should call #fetchExt when data is external', ->
      spy = sinon.stub(@extDataSource, 'fetchExt')
      @extDataSource.fetchData()
      expect(spy).to.have.been.called

    it 'should call #fetchInt when data is internal', ->
      spy = sinon.stub(@intDataSource, 'fetchInt')
      @intDataSource.fetchData()
      expect(spy).to.have.been.called

  describe '#fetchExt', ->
    # still not sure how to tests these

  describe '#fetchInt', ->
    # still not sure how to tests these
