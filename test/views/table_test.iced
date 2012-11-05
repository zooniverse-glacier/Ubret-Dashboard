Table = require 'views/table'
Tool = require 'models/tool'

describe 'Table', ->
  it 'should be defined', ->
    expect(Table).to.be.ok

  it 'should be instantiable', ->
    table = new Table
    expect(table).to.be.ok

  describe 'instatiation', ->
    beforeEach ->
      @table = new Table

    it 'should use the table tag', ->
      expect(@table.el.nodeName).to.be('TABLE')

    it 'should have the table-tool class', ->
      expect(@table.$el).to.have.class('table-tool')

  describe '#render', ->
    beforeEach ->
      @tool = new Tool
      @toolStub = sinon.stub(@tool, 'getData').returns( [ new Backbone.Model { id: 1, name: 'woohooo' } ] )
      @table = new Table { model: @tool, id: 'table-1' }
      @templateSpy = sinon.spy(@table, 'template')
      @htmlSpy = sinon.spy(@table.$el, 'html')
      @ubretSpy = sinon.spy(@table, 'ubretTable')
      @table.render()

    it 'should render the table template', ->
      expect(@templateSpy).to.have.been.called

    it 'should append to el', ->
      expect(@htmlSpy).to.have.been.called

    it 'should create a new Ubret Table', ->
      expect(@ubretSpy).to.have.been.called

  describe '#dataKeys', ->
    it 'should extract all keys from the tool\'s data', ->
      @tool = new Tool
      @toolStub = sinon.stub(@tool, 'getData').returns( [ new Backbone.Model { id: 1, name: 'woohooo' } ] )
      @table = new Table { model: @tool, id: 'table-1' }
      expect(@table.dataKeys()[0]).to.equal('name')
