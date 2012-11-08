Tools = require 'collections/tools'

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
      tools = new Tools
      @toolWindow = new ToolWindow { collection: tools }

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
      tools = new Tools
      topLeftModel = new Backbone.Model { top: 20, left: 20, zindex: 0, name: 'test' } 
      tools.add topLeftModel
      @toolWindow = new ToolWindow { collection: tools, model: topLeftModel }
      @toolWindow.generatePosition()

    it 'should set the left css property to the model\'s left value', ->
      expect(@toolWindow.$el).to.have.css('left').be(@toolWindow.model.get('top'))

    it 'should set the top css property to the model\'s top value', ->
      expect(@toolWindow.$el).to.have.css('top').be(@toolWindow.model.get('left'))

  describe '#setWindowSize', ->
    beforeEach ->
      tools = new Tools
      heightWidthModel = new Backbone.Model { height: 10, width: 10, zindex: 0, name: 'test' } 
      tools.add heightWidthModel
      @toolWindow = new ToolWindow { collection: tools, model: heightWidthModel }

    it 'should set css height to the model\'s height', ->
      expect(@toolWindow.$el).to.have.css('height').be(10)

    it 'should set css width to the model\'s width', ->
      expect(@toolWindow.$el).to.have.css('width').be(10)

  describe '#toggleSettings', ->
    beforeEach ->
      @toolWindow = new ToolWindow { model: new Backbone.Model { width: 640, height: 480 } }
      @toggle = sinon.spy(@toolWindow.$el, 'toggleClass')
      @toolWindow.toggleSettings()

    it 'should toggle the settings-active class', ->
      expect(@toggle).to.have.been.calledWith('settings-active')

  describe '#close', ->
    beforeEach ->
      @toolWindow = new ToolWindow { model: new Backbone.Model {stuff: 2} }
      @modelSpy = sinon.spy(@toolWindow.model, 'destroy')
      @viewSpy = sinon.spy(@toolWindow, 'remove')
      @toolWindow.close()

    it 'should destroy the model', ->
      expect(@modelSpy).to.have.been.called

    it 'should remove the view', ->
      expect(@viewSpy).to.have.been.called

  describe '#startDrag', ->
    beforeEach ->
      @toolWindow = new ToolWindow
      @toolContainer = sinon.stub(@toolWindow.toolContainer, 'render').returns({ el: "nuffin" })
      @titleBar = sinon.stub(@toolWindow.titleBar, 'render').returns({ el: "nuffin" })
      @toolSettings = sinon.stub(@toolWindow.settings, 'render').returns({ el: "nuffin" })
      @documentSpy = sinon.stub($(document), 'on')

      @toolWindow.render().startDrag

    it 'should become unselectable', ->
      expect(@toolWindow.$el).to.have.class('unselectable')

    it 'should listen for mouse moves on the document', ->
      expect(@documentSpy).to.have.been.called

    describe '#endDrag', ->
      beforeEach ->
        @documentSpy = sinon.stub($(document), 'off')
        @toolWindow.endDrag()

        it 'should remove the unselectable class', ->
          expect(@toolWindow.$el).to.not.have.class('unselectable')

        it 'should remove the event listener from document', ->
          expect(@documentSpy).to.have.been.called
