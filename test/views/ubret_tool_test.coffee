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

  describe '#dataKeys', ->
    beforeEach ->
      @ubretTool = new UbretTool { id: 'table-1' }
      @data = [ new Backbone.Model { id: 1, name: 'woohooo' }, new Backbone.Model { id: 2, name: 'yolo' } ]
      @mediatorStub = sinon.stub(Backbone.Mediator, 'publish')
      @keys = @ubretTool.dataKeys(@data)

    afterEach ->
      Backbone.Mediator.publish.restore()

    it 'should extract all keys from the tool\'s data', ->
      expect(@keys[0]).to.equal('name')

    it 'should publish data to the global pubsub', ->
      expect(@mediatorStub).to.have.been.called
