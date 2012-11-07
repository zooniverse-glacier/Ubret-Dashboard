GraphSettings = require 'views/graph_settings'

describe 'GraphSettings', ->
  it 'should be defined', ->
    expect(GraphSettings).to.be.ok

  it 'should be instantiable', ->
    graphSettings = new GraphSettings
    expect(graphSettings).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @graphSettings = new GraphSettings

    it 'should use a div as its tag', ->
      expect(@graphSettings.el.nodeName).to.be('DIV')

    it 'should have a class GraphSettings-settings', ->
      expect(@graphSettings.$el).to.have.class('graph-settings')

  describe '#render', ->
    beforeEach ->
      @graphSettings = new GraphSettings { model: new Backbone.Model { type: 'histogram' } }
      @graphSettings.setKeys ['name', 'test']
      @templateSpy = sinon.spy(@graphSettings, 'template')
      @htmlSpy = sinon.spy(@graphSettings.$el, 'html')
      @graphSettings.render()

    it 'should render the template', ->
      expect(@templateSpy).to.have.been.called

    it 'should append to the el\'s html', ->
      expect(@htmlSpy).to.have.been.called

    describe 'when it is a histogram', ->
      beforeEach ->
        @disableYAxis = sinon.stub(@graphSettings, 'disableYAxis')
        @graphSettings.model = new Backbone.Model { type: 'histogram' }
        @graphSettings.render()

      it 'should call the disableYAxis function', ->
        expect(@disableYAxis).to.have.been.called

  describe '#disableYAxis', ->
    beforeEach ->
      @graphSettings = new GraphSettings
      @graphSettings.render().disableYAxis()

    it 'should disable the y-axis select element', ->
      expect(@graphSettings.$('select.y-axis')).to.have.attr('disabled')


