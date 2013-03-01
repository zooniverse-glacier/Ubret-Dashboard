Tools = require 'collections/tools'
Tool = require 'models/tool'

describe 'Tool', ->
  beforeEach ->
    @tools = new Tools
    @tools.add [
      tool_type: 'Table'
      name: "Table-1"
      id: 1
      data_source:
        source_type: "external"
        source: 1
    ,
      id: 2
      tool_type: 'Table'
      data_source:
        source: 1
        source_type: 'internal'
    ]

    @tool = @tools.at(0)
    @tool2 = @tools.at(1)

    @xhr = sinon.useFakeXMLHttpRequest()
    @requests = []
    @xhr.onCreate = (xhr) =>
      @requests.push xhr

  it 'should be instantiable', ->
    expect(@tool).to.be.defined

  describe '#generatePosition', ->
    beforeEach ->
      @tool.generatePosition()

    it 'should assign a top attribute to the tool', ->
      expect(@tool.attributes).to.have.property('top')

    it 'should assign a left atribute to the tool', ->
      expect(@tool.attributes).to.have.property('left')

  describe '#sourceTool', ->
    it 'should retrieve the source tool of a internal tool', ->
      expect(@tool2.sourceTool()).to.be(@tool)

    it 'should return false if the tool is not internal', ->
      expect(@tool.sourceTool()).to.beFalse

  describe '#sourceName', ->
    it 'should return the name of the tool it is connected to', ->
      expect(@tool2.sourceName()).to.be("Table-1")

  describe "#destroy", ->
    it 'should call destory on any child tools', ->
      destroySpy = sinon.spy(@tool2, "destroy")
      @tool.destroy()
      expect(destroySpy).to.have.been.called

  describe "#updateFunc", ->
    it 'should call set when tool does not have an id', ->
      @tool.id = null
      setSpy = sinon.spy(@tool, "set")
      @tool.updateFunc "test", 1
      expect(setSpy).to.have.been.called

    it 'should call save when the tool does have an id', ->
      saveSpy = sinon.spy(@tool, "save")
      @tool.updateFunc "test", 1
      expect(saveSpy).to.have.been.called
