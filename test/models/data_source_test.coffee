DataSource = require 'models/data_source'
GalaxyZooSubjects = require 'collections/galaxy_zoo_subjects'

describe 'DataSource', ->
  it 'should be defined', ->
    expect(DataSource).to.be.ok

  it 'should be instantiable', ->
    dataSource = new DataSource
    expect(dataSource).to.be.ok

  describe 'attributes', ->
    it 'should have a data attribute that based on the data source', ->
      dataSource = new DataSource { source: 'Galaxy Zoo' }
      sinon.spy(dataSource.get('data'), 'fetch')
      expect(dataSource.get('data')).to.be.an.instanceof(GalaxyZooSubjects)

  describe '#sourceToCollection', ->
    it 'should convert the string name of the source into the class name of the collection', ->
      dataSource = new DataSource { source: 'Galaxy Zoo' }
      expect(dataSource.sourceToCollection()).to.equal(GalaxyZooSubjects)

    it 'should return "internal" if the source is another tool', ->
      dataSource = new DataSource { source: 'tool-1' }
      expect(dataSource.sourceToCollection()).to.equal('internal')

  describe '#fetchData', ->
    it 'should call the data collection\'s fetch method', ->
      dataSource = new DataSource { source: 'Galaxy Zoo' }
      fetchSpy = sinon.stub(dataSource.get('data'), 'fetch')
      dataSource.fetchData()
      expect(fetchSpy).to.have.been.called

  describe '#isExternal', ->
    it 'should return true if it has an external source', ->
      dataSource = new DataSource { source: 'Galaxy Zoo' }
      expect(dataSource.isExternal()).to.be.true

    it 'should return false if it has an internal dataSource', ->
      dataSource = new DataSource { source: 'tool-1' }
      expect(dataSource.isExternal()).to.be.false

  describe '#dataExtents', ->
    it 'should calculat the minimum and maximum values for a colleciton given the selectedElements and selectedKey', ->
      datum1 = new Backbone.Model({id: 1, point: 3, pointy: 5})
      datum2 = new Backbone.Model({id: 2, point: 5, pointy: 1})
      datum3 = new Backbone.Model({id: 3, point: 8, pointy: 10})
      datum4 = new Backbone.Model({id: 4, point: 6, pointy: 4})
      data = new Backbone.Collection [ datum1, datum2, datum3, datum4 ]
      dataSource = new DataSource { data: data }
      extents = dataSource.dataExtents('point', [2, 3, 4])
      expect(extents).to.have.property('min').and.equal(5)
      expect(extents).to.have.property('max').and.equal(8)
