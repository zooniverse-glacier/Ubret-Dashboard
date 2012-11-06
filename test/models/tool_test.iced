Tool = require 'models/tool'
DataSource = require 'models/data_source'
Filters = require 'collections/filters'

describe 'Tool', ->
  it 'should be defined', ->
    expect(Tool).to.be.ok

  it 'should be instantiable', ->
    tool = new Tool
    expect(tool).to.be.ok

  describe 'defaults', ->
    beforeEach ->
      @tool = new Tool

    it 'should have a height of 640', ->
      expect(@tool.get('height')).to.equal(480)

    it 'should have a width of 480', ->
      expect(@tool.get('width')).to.equal(640)

    it 'should have a new DataSource', ->
      expect(@tool.get('dataSource')).to.be.an.instanceof(DataSource)

    it 'should have a new Filters collection', ->
      expect(@tool.get('filters')).to.be.an.instanceof(Filters)

    it 'should have a top of 20', ->
      expect(@tool.get('top')).to.equal(20)

    it 'should have a left of 20', ->
      expect(@tool.get('left')).to.equal(20)

    it 'should have a z-index of 1', ->
      expect(@tool.get('z-index')).to.equal(1)

  describe '#getData', ->
    beforeEach ->
      @tool = new Tool { dataSource: new DataSource { source: 'Galaxy Zoo' } }

  describe '#filterData', ->
    beforeEach ->
      @filter = new Backbone.Model { func: (x) -> x }
      @filters = new Filters [@filter]
      @tool = new Tool { filters: @filters, dataSource: new DataSource { source: 'Galaxy Zoo' } }
      @toolStub = sinon.stub(@tool.get('dataSource'), 'get').returns(new Backbone.Collection [{id: 1, test: 2}, {id: 2, test: 3}])
      @eachSpy = sinon.spy(@tool.get('filters'), 'each')
      @filterSpy = sinon.spy(_, 'filter')
      @tool.filterData()

    afterEach ->
      @tool.get('filters').each.restore()
      _.filter.restore()

    it 'should call each on filters', ->
      expect(@eachSpy).to.have.been.called

    it 'should filter data', ->
      expect(@filterSpy).to.have.been.called