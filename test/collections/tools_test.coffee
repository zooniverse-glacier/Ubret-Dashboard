Tools = require 'collections/tools'
DataSource = require 'models/data_source'
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

  describe '#bindTool', ->
    beforeEach ->
      @tool1 = new Tool { channel: 'tool-1', dataSource: new DataSource {source: 'Galaxy Zoo'} }
      @tool2 = new Tool { channel: 'tool-2', dataSource: new DataSource {source: 'tool-1'} }
      @tools = new Tools [@tool1, @tool2]
      @bindToolStub = sinon.stub(@tool2, 'bindTool')
      @tools.bindTool('tool-1', @tool2)

    it 'should call the binding tool\'s bindTool method and pass the tool to be bound to', ->
      expect(@bindToolStub).to.have.been.calledWith(@tool1)
