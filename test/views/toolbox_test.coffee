Toolbox = require 'views/toolbox'

describe 'Toolbox', ->
  it 'should be defined', ->
    expect(Toolbox).to.be.ok

  it 'should be instantiable', ->
    toolbox = new Toolbox
    expect(toolbox).to.be.ok

  describe 'instantiation', ->
    beforeEach -> 
      @toolbox = new Toolbox

    it 'should use a div tag', ->
      expect(@toolbox.el.nodeName).to.be('DIV')

    it 'should have class name toolbox', ->
      expect(@toolbox.$el).to.have.class('toolbox')

  describe '#render', ->
    beforeEach ->
      @toolbox = new Toolbox
      @templateSpy = sinon.spy(@toolbox, 'template')
      @toolbox.render()

    it 'should render template', ->
      expect(@templateSpy).to.have.been.called

  describe '#createTool', ->
    beforeEach ->
      @toolbox = new Toolbox
      @triggerSpy = sinon.spy(@toolbox, 'trigger')
      @toolbox.render().$el.find('button[name="table"]').click()

    it 'should trigger a create-table event', ->
      expect(@triggerSpy).to.have.been.calledWith('create', 'table')

  describe '#createTool', ->
    beforeEach ->
      @toolbox = new Toolbox
      @triggerSpy = sinon.spy(@toolbox, 'trigger')
      @toolbox.render().$el.find('button[name="remove-tools"]').click()

    it 'should trigger a create-table event', ->
      expect(@triggerSpy).to.have.been.calledWith('remove-tools')
