UbretTool = require 'views/ubret_tool'
Tool = require 'models/tool'

describe 'UbretTool', ->
  it 'should be defined', ->
    expect(UbretTool).to.be.ok

  it 'should be instantiable', ->
    ubretTool = new UbretTool
    expect(ubretTool).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @ubretTool = new UbretTool

    it 'should use a div tag', ->
      expect(@ubretTool.el.nodeName).to.be('DIV')

    it 'should have ubret-tool as its class name', ->
      expect(@ubretTool.$el).to.have.class 'ubret-tool'

  describe '#render', ->
    beforeEach ->
      @model = new Tool { type: 'table', id: 'test-1' }
      @ubretTool = new UbretTool { model: @model, id: @model.id }
      @htmlSpy = sinon.spy(@ubretTool.$el, 'html')

    describe 'no data', ->
      beforeEach ->
        @modelStub = sinon.stub(@model, 'getData').returns([])
        @templateSpy = sinon.spy(@ubretTool, 'noDataTemplate')
        @ubretTool.render()

      it 'should render the no data template', ->
        expect(@templateSpy).to.have.been.called

      it 'should append template to el', ->
        expect(@htmlSpy).to.have.been.called

    describe 'template for the tool', ->
      beforeEach ->
        @modelStub = sinon.stub(@model, 'getData').returns([new Backbone.Model { test: 'test', id: 1, name: 'whoops' }])
        @templateSpy = sinon.spy(@ubretTool, 'template')
        @ubretTool.render()

      it 'should render the tool\'s template', ->
        expect(@templateSpy).to.have.been.called

      it 'should append the template to el', ->
        expect(@htmlSpy).to.have.been.called

  describe '#dataKeys', ->
    it 'should extract all keys from the tool\'s data', ->
      @ubretTool = new UbretTool { id: 'table-1' }
      data = [ new Backbone.Model { id: 1, name: 'woohooo' }, new Backbone.Model { id: 2, name: 'yolo' } ]
      expect(@ubretTool.dataKeys(data)[0]).to.equal('name')

  describe '#formatToolType', ->
    it 'should capitalize the first letter of a word', ->
      @ubretTool = new UbretTool
      expect(@ubretTool.formatToolType('table')).to.be('Table')
