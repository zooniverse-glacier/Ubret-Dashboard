FilterSettings = require 'views/filter_settings'

describe 'FilterSettings', ->
  it 'should be defined', ->
    expect(FilterSettings).to.be.ok

  it 'should be instantiable', ->
    filterSettings = new FilterSettings
    expect(filterSettings).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @filterSettings = new FilterSettings

    it 'should have a div node', ->
      expect(@filterSettings.el.nodeName).to.be('DIV')

    it 'should have the filter-settings class', ->
      expect(@filterSettings.$el).to.have.class('filter-settings')

  describe '#render', ->
    beforeEach ->
      @filterSettings = new FilterSettings
      @templateSpy = sinon.spy(@filterSettings, 'template')
      @htmlSpy = sinon.spy(@filterSettings.$el, 'html')
      @filterSettings.render()

    it 'should render the template', ->
      expect(@templateSpy).to.have.been.called

    it 'should append the template', ->
      expect(@htmlSpy).to.have.been.called
