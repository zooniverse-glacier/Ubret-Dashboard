ToolContainer = require 'views/tool_container'
Tool = require 'models/tool'

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

  describe '#render', ->
    beforeEach ->
      @tool = new Tool { type: 'table', channel: 'table-1' }
      @container = new ToolContainer { model: @tool }
      @renderSpy = sinon.spy(@container.toolView, 'render')
      @htmlSpy = sinon.spy(@container.$el, 'html')
      @container.render()

    it 'should render its toolView', ->
      expect(@renderSpy).to.have.been.called

    it 'should append the rendered toolView', ->
      expect(@htmlSpy).to.have.been.calledWith(@container.toolView.el)
