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
      @htmlSpy = sinon.spy(@title.$el. 'template')

  describe 'close', ->
    beforeEach ->
      @title = new WindowTitleBar
