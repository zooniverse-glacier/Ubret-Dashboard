Tool = require 'models/tool'

describe 'Tool', ->
  beforeEach ->
    @tool = new Tool

  it 'should be instantiable', ->
    expect(@tool).to.be.defined

  describe '#toJSON', ->
    it 'should include settings in the generated json', ->
      expect(@tool.toJSON()).to.have.property('settings')

  describe '#generatePosition', ->
    beforeEach ->
      @tool.generatePosition()

    it 'should assign a top attribute to the tool', ->
      expect(@tool.attributes).to.have.property('top')

    it 'should assign a left atribute to the tool', ->
      expect(@tool.attributes).to.have.property('left')

