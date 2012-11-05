DataSettings = require 'views/data_settings'

describe 'DataSettings', ->
  it 'should be defined', ->
    expect(DataSettings).to.be.ok

  it 'should be instantiable', ->
    dataSettings = new DataSettings
    expect(dataSettings).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @dataSettings = new DataSettings

    it 'should have a div tag', ->
      expect(@dataSettings.el.nodeName).to.be("DIV")

    it 'should have a data-settings class', ->
      expect(@dataSettings.$el).to.have.class('data-settings')

  describe '#render', ->
    beforeEach ->
      @dataSettings = new DataSettings
      @templateSpy = sinon.spy(@dataSettings, 'template')
      @htmlSpy = sinon.spy(@dataSettings.$el, 'html')
      @dataSettings.render()

    it 'should render the template', ->
      expect(@templateSpy).to.have.been.called

    it 'should append the template to el', ->
      expect(@htmlSpy).to.have.been.called

  describe '#showExternal', ->
    beforeEach ->
      @dataSettings = new DataSettings
      @dataSettings.render().showExternal()

    it 'should hide the interal settings', ->
      expect(@dataSettings.$('.internal-settings')).to.be.hidden

    it 'should show the external settings', ->
      expect(@dataSettings.$('.external-settings')).to.be.visible

    it 'should show the fetch button', ->
      expect(@dataSettings.$('button[name="fetch"]')).to.be.visible

  describe '#showInternal', ->
    beforeEach ->
      @dataSettings = new DataSettings
      @dataSettings.render().showInternal()

    it 'should show the internal settings', ->
      expect(@dataSettings.$('.internal-settings')).to.be.visible

    it 'should hide the external settings', ->
      expect(@dataSettings.$('.external-settings')).to.be.hidden

    it 'should show the fetch button', ->
      expect(@dataSettings.$('button[name="fetch"]')).to.be.visible

  describe '#updateToolList', ->
    beforeEach ->
      @dataSettings = new DataSettings
      @renderSpy = sinon.stub(@dataSettings, 'render')
      @dataSettings.updateToolList [{ name: 'test', channel: 'test-1' }]

    it 'should set intSources property', ->
      expect(@dataSettings).to.have.property('intSources').and.equal([{name: 'test', channel: 'test-1'}])

    it 'should call render function', ->
      expect(@renderSpy).to.have.been.called
