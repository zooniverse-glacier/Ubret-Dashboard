Table = require 'views/table'

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
      @tool = new Backbone.Model
        dataSource: new Backbone.Model
          data: new Backbone.Collection [ { id: 1, name: 'test' }, { id: 2, name: 'test 2'} ]
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
      @tool = new Backbone.Model
        dataSource: new Backbone.Model
          data: new Backbone.Collection [ { id: 1, name: 'test' }, { id: 2, name: 'test 2'} ]
      @table = new Table { model: @tool, id: 'table-1' }
      expect(@table.dataKeys()[0]).to.equal('name')
      

