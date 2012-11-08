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
