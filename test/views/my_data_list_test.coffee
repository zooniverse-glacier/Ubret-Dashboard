shouldBehaveLikeAMyDataList = ->
  it 'should be defined', ->
    expect(@list).to.be.ok

  describe '#url', ->
    it 'should retieve the url function for the zooniverse query', ->
      expect(@list.url()).to.be.a('function')

  describe '#reset', ->
    it 'should call reset when there is a defined collection', ->
      @list.collection = new Backbone.Collection
      resetSpy = sinon.spy(@list.collection, 'reset')
      @list.reset()
      expect(resetSpy).to.have.been.called

  describe '#loadCollection', ->
    beforeEach ->
      @renderSpy = sinon.stub(@list, 'render')

    context 'when there is not collection', ->
      it 'should create a new collection', ->
        sinon.stub(@list, 'url').returns((-> 'hi'))
        @list.zooniverse = class Collection
          fetch: -> {done: -> 'hi'}
        @list.collection = null
        @list.loadCollection()
        expect(@list).to.have.property('collection')

  describe '#render', ->
    context 'when there is no collection', ->
      it 'should render the noProjectTemplate', ->
        @list.collection = undefined
        tempSpy = sinon.spy(@list, 'noProjectTemplate')
        @list.render()
        expect(tempSpy).to.have.been.called

    context 'when there is a collection', ->
      beforeEach ->
        @list.collection = new Backbone.Collection [{id: 1 }, {id: 2}, {id: 3}]

      it 'should render template', ->
        tempSpy = sinon.spy(@list, 'template')
        @list.render()
        expect(tempSpy).to.have.been.called

      it 'should render the item template for each model in collection', ->
        tempSpy = sinon.spy(@list, 'templateItem')
        @list.render()
        expect(tempSpy).to.have.been.calledThrice

module.exports = shouldBehaveLikeAMyDataList

