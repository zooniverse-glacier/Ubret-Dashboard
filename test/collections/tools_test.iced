Tools = require 'collections/tools'
Tool = require 'models/tool'

describe 'Tools', ->
  it 'should be defined', ->
    expect(Tools).to.be.ok

  it 'should be instantiable', ->
    tools = new Tools
    expect(tools).to.be.ok

  describe 'properties', ->
    beforeEach ->
      @tools = new Tools

    it 'should use Tool as it\'s model', ->
      expect(@tools).to.have.property('model').and.equal(Tool)

