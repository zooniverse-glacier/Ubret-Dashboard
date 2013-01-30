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
      @saveSpy = sinon.spy(@tool, 'save')
      @setSpy = sinon.spy(@tool, 'set')

    it 'should set the tool\'s zindex if the tool does not have the highest zindex ', ->
      @tools.focus(@tool)
      expect(@tool.attributes).to.have.property('zindex')
        .that.is.a('number')
        .and.is.equal(4)

    it 'should not set the tool\'s zindex if the tool already has the highest zindex', ->
      @tools.focus(@highestTool)
      expect(@highestTool.attributes).to.have.property('zindex')
        .that.is.a('number')
        .and.is.equal(3)
      expect(@saveSpy).to.not.have.been.called
      expect(@setSpy).to.not.have.been.called

    it 'should save the tool', ->
      @tools.focus(@tool)
      expect(@saveSpy).to.have.been.called

    it 'should not save when false is passed', ->
      @tools.focus(@tool, false)
      expect(@saveSpy).to.not.have.been.called

  describe '#loadTools', ->
    # I actually have no idea how to even start testing this

  # describe '#setDataSource', ->
  #   beforeEach ->
  #     @tool = @tools.at(0)
  #     @tool.get('dataSource').set { type: 'internal', source: 'table-3' }, {silent: true}

  #   it 'should set the source tool for an internal tool', ->
  #     @tools.setDataSource(@tool)
  #     expect(@tool.get('dataSource')).to.have.property('source', @tools.at(3))




