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
      sinon.spy(dataSource.get('data'), 'fetch')
      expect(dataSource.sourceToCollection()).to.equal(GalaxyZooSubjects)

  describe '#fetchData', ->
    it 'should call the data collection\'s fetch method', ->
      dataSource = new DataSource { source: 'Galaxy Zoo' }
      fetchSpy = sinon.spy(dataSource.get('data'), 'fetch')
      dataSource.fetchData()
      expect(fetchSpy).to.have.been.called
