Settings = require 'views/settings'
DataSettings = require 'views/data_settings'

describe 'Settings', ->
  it 'should be defined', ->
    expect(Settings).to.be.ok

  it 'should be instantiable', ->
    settings = new Settings
    expect(settings).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @model = new Backbone.Model { dataSource: new Backbone.Model }
      @settings = new Settings { model: @model }

    it 'should have a div tag', ->
      expect(@settings.el.nodeName).to.be('DIV')

    it 'should have the settings class', ->
      expect(@settings.$el).to.have.class('settings')

    describe '#initialize', ->
      it 'should have a data settings view', ->
        expect(@settings).to.have.property('dataSettings').and.be.an.instanceof(DataSettings)

  describe '#render', ->
    beforeEach ->
      @model = new Backbone.Model { dataSource: new Backbone.Model }
      @settings = new Settings { model: @model }
      @dataSettingsStub = sinon.stub(@settings.dataSettings, 'render').returns({ el: '<p>woohoo</p>' })
      @appendSpy = sinon.spy(@settings.$el, 'append')
      @settings.render()

    it 'should render the data settings', ->
      expect(@dataSettingsStub).to.have.been.called

    it 'should append the rendered sub-settings to the main el', ->
      expect(@appendSpy).to.have.been.called
