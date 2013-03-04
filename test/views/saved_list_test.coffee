SavedList = require 'views/saved_list'

describe "Saved List", ->
  beforeEach ->
    @savedList = new SavedList
      collection: new Backbone.Collection [{id: 1}, {id: 2}, {id: 3}]

  it 'should be instantiable', ->
    expect(@savedList).to.be.defined

