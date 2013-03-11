SavedList = require 'views/saved_list'

describe "Saved List", ->
  beforeEach ->
    @savedList = new SavedList
      collection: new Backbone.Collection [{id: 1, name: "test", updated_at: "2013-01-23"},
                                           {id: 2, name: "test", updated_at: "2013-01-23"}, 
                                           {id: 3, name: "test", updated_at: "2013-01-23"}]

  it 'should be instantiable', ->
    expect(@savedList).to.be.defined

  it 'should have a sharer for each item in collection', ->
    expect(@savedList).to.have.property('sharers')

  describe "#render", ->

    it 'should render the main template', ->
      listSpy = sinon.spy(@savedList, "listTemplate")
      @savedList.render()
      expect(listSpy).to.have.been.called

    it 'should render each member of the collection', ->
      itemSpy = sinon.spy(@savedList, "itemTemplate")
      @savedList.render()
      expect(itemSpy).to.have.been.calledThrice

  describe '#shareDashboard', ->
    it 'should call openSharer', ->
      event = { preventDefault: ( -> 'hi'), currentTarget: {dataset: {id: 1}}}
      openSpy = sinon.spy(@savedList, 'openSharer')

      @savedList.shareDashboard event
      expect(openSpy).to.have.been.called

  describe '#deleteDashboard', ->
    it 'should call removeDashboard', ->
      event = { preventDefault: ( -> 'hi'), currentTarget: {dataset: {id: 1}}}
      removeSpy = sinon.stub(@savedList, 'removeDashboard')

      @savedList.deleteDashboard event
      expect(removeSpy).to.have.been.called
      
      



     

