MyData = require 'views/my_data'
Recents = require 'views/recents'
Favorites = require 'views/favorites'

describe 'MyData', ->
  beforeEach ->
    @myData = new MyData

  it 'should be instantiable', ->
    expect(@myData).to.be.ok

  it 'should have a favorites and a recents view', ->
    expect(@myData).to.have.property('recents').and.be.an.instanceOf(Recents)
    expect(@myData).to.have.property('favorites').and.be.an.instanceOf(Favorites)

  describe '#loadCollections', ->
    it 'should call loadCollection on favorites and recents', ->
      recentSpy = sinon.stub(@myData.recents, 'loadCollection')
      favSpy = sinon.stub(@myData.favorites, 'loadCollection')
      colSpy = sinon.stub(@myData.collections, 'loadCollection')
      @myData.loadCollections()
      expect(recentSpy).to.have.been.called
      expect(favSpy).to.have.been.called
      expect(colSpy).to.have.been.called

  describe '#resetCollection', ->
    it 'should call reset on favorites and recents', ->
      recentSpy = sinon.stub(@myData.recents, 'reset')
      favSpy = sinon.stub(@myData.favorites, 'reset')
      colSpy = sinon.stub(@myData.collections, 'reset')
      @myData.resetCollections()
      expect(recentSpy).to.have.been.called
      expect(favSpy).to.have.been.called
      expect(colSpy).to.have.been.caleed
