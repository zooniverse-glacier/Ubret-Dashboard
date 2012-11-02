ToolWindow = require 'views/tool_window'
Settings = require 'views/settings'
ToolContainer = require 'views/tool_container'
WindowTitleBar = require 'views/window_title_bar'

describe 'ToolWindow', ->
  it 'should be defined', ->
    expect(ToolWindow).to.be.ok

  it 'should be instantiable', ->
    toolWindow = new ToolWindow
    expect(toolWindow).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @toolWindow = new ToolWindow

    it 'should have a div tag', ->
      expect(@toolWindow.el.nodeName).to.equal('DIV')

    it 'should have a tool-window class', ->
      expect(@toolWindow.$el).to.have.class('tool-window')

    describe '#initialize', ->
      it 'should create a window title bar', ->
        expect(@toolWindow).to.have.property('titleBar').and.to.be.an.instanceof(WindowTitleBar)

      it 'should create a tool container', ->
        expect(@toolWindow).to.have.property('toolContainer').and.to.be.an.instanceof(ToolContainer)

      it 'should create a settings container', ->
        expect(@toolWindow).to.have.property('settings').and.to.be.an.instanceof(Settings)

  describe '#render', ->
    beforeEach ->
      @toolWindow = new ToolWindow

      @toolContainer = sinon.stub(@toolWindow.toolContainer, 'render').returns({ el: "nuffin" })
      @titleBar = sinon.stub(@toolWindow.titleBar, 'render').returns({ el: "nuffin" })
      @toolSettings = sinon.stub(@toolWindow.settings, 'render').returns({ el: "nuffin" })
      @append = sinon.stub(@toolWindow.$el, 'append')

      @toolWindow.render()

    it 'should render the title bar', ->
      expect(@titleBar).to.have.been.called

    it 'should render the tool container', ->
      expect(@toolContainer).to.have.been.called

    it 'should render the tool settings', ->
      expect(@toolSettings).to.have.been.called

    it 'should append everything to el', ->
      expect(@append).to.have.been.calledThrice

  describe '#setWindowPosition', ->
    beforeEach ->
      topLeftModel = new Backbone.Model { top: 20, left: 20, name: 'test' } 
      @toolWindow = new ToolWindow { model: topLeftModel }

    it 'should set the left css property to the model\'s left value', ->
      expect(@toolWindow.$el).to.have.css('left').be(20)

    it 'should set the top css property to the model\'s top value', ->
      expect(@toolWindow.$el).to.have.css('top').be(20)

  describe '#setWindowSize', ->
    beforeEach ->
      heightWidthModel = new Backbone.Model { height: 10, width: 10, name: 'test' } 
      @toolWindow = new ToolWindow { model: heightWidthModel }

    it 'should set css height to the model\'s height', ->
      expect(@toolWindow.$el).to.have.css('height').be(10)

    it 'should set css width to the model\'s width', ->
      expect(@toolWindow.$el).to.have.css('width').be(10)

  describe '#toggleSettings', ->
    it 'should toggle the settings-active class', ->
      toolWindow = new ToolWindow
      toggle = sinon.spy(toolWindow.$el, 'toggleClass')
      toolWindow.toggleSettings()
      expect(toggle).to.have.been.calledWith('settings-active')
  
  describe '#close', ->
    beforeEach ->
      @toolWindow = new ToolWindow { model: new Backbone.Model {stuff: 1, stuff: 2} }
      @modelSpy = sinon.spy(@toolWindow.model, 'destroy')
      @viewSpy = sinon.spy(@toolWindow, 'remove')
      @toolWindow.close()

    it 'should destroy the model', ->
      expect(@modelSpy).to.have.been.called

    it 'should remove the view', ->
      expect(@viewSpy).to.have.been.called
