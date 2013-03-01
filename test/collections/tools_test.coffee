Tools = require 'collections/tools'

describe 'Tools', ->
  beforeEach ->
    # Turns out if you batch add new objects to a collection, Backbone does not update
    # collection.length between models. Since we depend upon collection.length to be
    # up-to-date, we have to add the tools individually.
    @tools = new Tools
    @tools.add {tool_type: 'table'}
    @tools.add {tool_type: 'table'}
    @tools.add {tool_type: 'table'}

  it 'should be instantiable', ->
    expect(@tools).to.be.defined

  it 'should load tools correctly', ->
    expect(@tools.length).to.equal(3)

  describe '#focus', ->
    beforeEach ->
      @tool = @tools.at(0)
      @highestTool = @tools.at(2)
      @updateSpy = sinon.spy(@tool, "updateFunc")

    it 'should set the tool\'s zindex if the tool does not have the highest zindex ', ->
      @tools.focus(@tool)
      expect(@tool.attributes).to.have.property('zindex')
        .that.is.a('number')
        .and.is.equal(4)
      expect(@updateSpy).to.have.been.called

    it 'should not set the tool\'s zindex if the tool already has the highest zindex', ->
      @tools.focus(@highestTool)
      expect(@highestTool.attributes).to.have.property('zindex')
        .that.is.a('number')
        .and.is.equal(3)
      expect(@updateSpy).to.not.have.been.called
