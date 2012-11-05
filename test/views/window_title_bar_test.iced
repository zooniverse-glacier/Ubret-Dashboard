WindowTitleBar = require 'views/window_title_bar'

describe 'WindowTitleBar', ->
  it 'should be defined', ->
    expect(WindowTitleBar).to.be.ok

  it 'should instantiable', ->
    titleBar = new WindowTitleBar
    expect(titleBar).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @titleBar = new WindowTitleBar

    it 'should use a div tag', ->
      expect(@titleBar.el.nodeName).to.equal('DIV')

    it 'should have the title-bar css class', ->
      expect(@titleBar.$el).to.have.class('title-bar')

  describe '#render', ->
    beforeEach ->
      @model = new Backbone.Model { name: 'new-tool' }
      @title = new WindowTitleBar { model: @model }
      @templateSpy = sinon.spy(@title, 'template')
      @htmlSpy = sinon.spy(@title.$el, 'html')
      @title.render()

    it 'should render the template', ->
      expect(@templateSpy).to.have.been.called

    it 'should append the html ', ->
      expect(@htmlSpy).to.have.been.called

    it 'should have a title', ->
      expect(@title.$('.window-title')).to.have.text('new-tool')

  describe '#close', ->
    beforeEach ->
      @title = new WindowTitleBar
      @triggerSpy = sinon.spy(@title, 'trigger')
      @title.close()

    it 'should trigger close event', ->
      expect(@triggerSpy).to.have.been.calledWith('close')

  describe '#settings', ->
    beforeEach ->
      @title = new WindowTitleBar
      @triggerSpy = sinon.spy(@title, 'trigger')
      @title.settings()

    it 'should trigger close event', ->
      expect(@triggerSpy).to.have.been.calledWith('settings')
     
  describe '#startDrag', ->
    beforeEach ->
      @title = new WindowTitleBar
      @triggerSpy = sinon.spy(@title, 'trigger')
      @title.startDrag()

    it 'should trigger close event', ->
      expect(@triggerSpy).to.have.been.calledWith('startDrag')

  describe '#endDrag', ->
    beforeEach ->
      @title = new WindowTitleBar
      @triggerSpy = sinon.spy(@title, 'trigger')
      @title.endDrag()

    it 'should trigger close event', ->
      expect(@triggerSpy).to.have.been.calledWith('endDrag')

  describe '#editTitle', ->
    beforeEach ->
      @title = new WindowTitleBar
      @title.render().editTitle()

    it 'should hide window title', ->
      expect(@title.$('.window-title')).to.be.hidden

    it 'should show the window title input field', ->
      expect(@title.$('input')).to.not.be.hidden

  describe '#updateModel', ->
    beforeEach ->
      @title = new WindowTitleBar { model: new Backbone.Model }
      @title.render().editTitle()
    
    describe 'when escape is pressed', ->
      beforeEach ->
        event = { which: 27 }
        @title.updateModel event

      it 'should show window title', ->
        expect(@title.$('.window-title')).to.not.be.hidden

      it 'should hide the window title input field', ->
        expect(@title.$('input')).to.be.hidden

    describe 'when a blur event is triggered or the enter key is pressed', ->
      beforeEach ->
        event = { type: 'blur', which: 13 }
        @modelSpy = sinon.spy(@title.model, 'set')
        @title.updateModel event

      it 'should get the model\'s name property', ->
        expect(@modelSpy).to.have.been.calledWith('name', '')
