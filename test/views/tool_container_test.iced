ToolContainer = require 'views/tool_container'

describe 'ToolContainer', ->
  it 'should be defined', ->
    expect(ToolContainer).to.be.ok

  it 'should be instantiable', ->
    toolContainer = new ToolContainer
    expect(toolContainer).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @toolContainer = new ToolContainer

    it 'should use a div tag', ->
      expect(@toolContainer.el.nodeName).to.equal('DIV')

    it 'should have the tool-container css class', ->
      expect(@toolContainer.$el).to.have.class('tool-container')

  describe '#createToolView', ->
    beforeEach ->
      @tool = new Backbone.Model { type: 'table' }
      @requireSpy = sinon.stub(window, 'require').returns(Backbone.View)
      @container = new ToolContainer { model: @tool }
      @container.createToolView()

    afterEach ->
      window.require.restore()

    it 'should require the view of the tool based on the model\'s type attribute', ->
      expect(@requireSpy).to.have.been.calledWith('views/table')

  describe '#render', ->
    beforeEach ->
      @tool = new Backbone.Model { type: 'table' }
      @requireSpy = sinon.stub(window, 'require').returns(Backbone.View)
      @container = new ToolContainer { model: @tool }
      @renderSpy = sinon.spy(@container.toolView, 'render')
      @htmlSpy = sinon.spy(@container.$el, 'html')
      @container.render()

    afterEach ->
      window.require.restore()

    it 'should render its toolView', ->
      expect(@renderSpy).to.have.been.called

    it 'should append the rendered toolView', ->
      expect(@htmlSpy).to.have.been.calledWith(@container.toolView.el)

