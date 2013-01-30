BaseModel = require 'models/base_model'

describe 'Base Model', ->
  beforeEach ->
    @baseModel = new BaseModel

  it 'should be instantiable', ->
    expect(@baseModel).to.be.defined