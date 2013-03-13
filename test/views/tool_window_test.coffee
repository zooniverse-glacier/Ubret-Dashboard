ToolWindow = require 'views/tool_window'

describe 'ToolWindow', ->
  beforeEach ->
    ToolWindow::settingsView = Backbone.View
    ToolWindow::windowTitleBarView = Backbone.View
    @model = new Backbone.Model 
      id: 1
      height: 200
      width: 200
      left: 10
      top: 10
      zindex: 1
      tool_type: 'Table'
    @model.tool = {el: '<div>Element</div>'}

    @window = new ToolWindow {model: @model}

  it 'should be defined', ->
    expect(@window).to.be.ok

  it 'should set the window\'s size and position', ->
    el = @window.$el
    expect(el).to.have.css 'height', '200px'
    expect(el).to.have.css 'width', '200px'
    expect(el).to.have.css 'top', '10px'
    expect(el).to.have.css 'left', '10px'
    expect(el).to.have.css 'z-index', '1'

  it 'should have the dashboard size', ->
    expect(@window).to.have.property('dashWidth').and.eq(window.innerWidth)
    expect(@window).to.have.property('dashTop').and.eq(170)
    expect(@window).to.have.property('dashBottom').and.eq(window.innerHeight - 70)
    expect(@window).to.have.property('dashHeight').and.eq(@window.dashBottom- @window.dashTop)

  it 'should have a setting view', ->
    expect(@window).to.have.property('settings').and.be.an.instanceOf(Backbone.View)
    expect(@window).to.have.property('titleBar').and.be.an.instanceOf(Backbone.View)

  describe '#initialSizeAndPosition', ->
    it 'should return a hash of the size and position properties of tool model', ->
      expect(@window.initialSizeAndPosition()).to.eql
        left: 10
        top: 10
        height: 200
        width: 200
        zindex: 1
        'z-index': 1

  describe '#updateWindowId', ->
    it 'should the id property of the window element to the model\'s id', ->
      @window.render()
      @window.updateWindowId()
      expect(@window.$el).to.have.attr 'data-id', '1'

  describe '#render', ->
    beforeEach ->
      @tmpSpy = sinon.spy(@window, 'template')
      @window.render()

    it 'should render window template', ->
      expect(@tmpSpy).to.have.been.called

    it 'should set window\'s data id', ->
      expect(@window.$el).to.have.attr 'data-id', '1'

    it 'should set the height of the tool', ->
      expect(@window.$('.tool-container')).to.have.css 'height', '175px'

    it 'should set the class of of the tool-container', ->
      expect(@window.$('.tool-container')).to.have.class 'Table'

    it 'should attach the tool el to tool-container', ->
      expect(@window.$('.tool-container')).to.have.html '<div>Element</div>'

  describe '#removeWindow', ->
    it 'should call remove on subview before removing itself', ->
      setSpy = sinon.spy(@window.settings, 'remove')
      titleSpy = sinon.spy(@window.titleBar, 'remove')
      removeSpy = sinon.spy(@window, 'remove')
      @window.removeWindow() 
      expect(setSpy).to.have.been.called
      expect(titleSpy).to.have.been.called
      expect(removeSpy).to.have.been.called

  describe '#minimize', ->
    it 'should toggle the minimized class', ->
      el = @window.$el

      @window.minimize()
      expect(el).to.have.class 'minimized'
      @window.minimize()
      expect(el).to.not.have.class 'minimized'

  describe '#close', ->
    it 'should destroy the model', ->
      destroySpy = sinon.stub(@model, 'destroy')
      @window.close()
      expect(destroySpy).to.have.been.called

  describe '#setZindex', ->
    it 'should set the window\'s z-index property', ->
      @model.set 'zindex', 2, {silent: true}
      @window.setZindex()
      expect(@window.$el).to.have.css 'z-index', '2'

  describe '#setPosition', ->
    it 'should set the top and left css properties', ->
      @model.set {top: 50, left: 50}, {silent: true}
      @window.setPosition()
      expect(@window.$el).to.have.css 'top', '50px'
      expect(@window.$el).to.have.css 'left', '50px'

  describe '#setSize', ->
    it 'should set the width and height properties', ->
      @model.set {width: 400, height: 600}, {silent: true}
      @window.setSize()
      expect(@window.$el).to.have.css 'width', '400px'
      expect(@window.$el).to.have.css 'height', '600px'

      
      
