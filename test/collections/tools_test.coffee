Tools = require 'collections/tools'

describe 'Tools', ->
  beforeEach ->
    @tools = new Tools [
      { top: 1, left: 1, type: 'table', name: 'awesome-table', channel: 'table-1', zindex: 1},
      { top: 1, left: 1, type: 'table', name: 'awesome-table', channel: 'table-2', zindex: 2},
      { top: 1, left: 1, type: 'table', name: 'awesome-table', channel: 'table-3', zindex: 3},
    ]

  it 'should be instantiable', ->
    expect(@tools).to.be.defined

  describe '#focus', ->
    beforeEach ->
      @tool = @tools.at(0)
      @saveSpy = sinon.spy(@tool, 'save')

    it 'should set the tool\'s zindex', ->
      @tools.focus(@tool)
      expect(@tool.attributes).to.have.property('zindex', 4)

    it 'should save the tool', ->
      @tools.focus(@tool)
      expect(@saveSpy).to.have.been.called

    it 'should not save when false is passed', ->
      @tools.focus(@tool, false)
      expect(@saveSpy).to.not.have.been.called

  describe '#loadTools', ->
    # I actually have no idea how to even start testing this

  describe '#setDataSource', ->
    beforeEach ->
      @tool = @tools.at(0)
      @tool.get('dataSource').set { type: 'internal', source: 'table-3' }, {silent: true}

    it 'should set the source tool for an internal tool', ->
      @tools.setDataSource(@tool)
      expect(@tool.get('dataSource')).to.have.property('source', @tools.at(3))




