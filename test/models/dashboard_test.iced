Dashboard = require 'models/dashboard'
Tools = require 'collections/tools'

describe 'Dashboard', ->
  responseJson = { id: 1, name: 'My Cool Dashboard', tools: new Tools }

  it 'should be defined', ->
    expect(Dashboard).to.be.ok

  it 'should be instantiable', ->
    dashboard = new Dashboard
    expect(dashboard).to.be.ok

  describe 'Defaults', ->
    beforeEach ->
      @dashboard = new Dashboard

    it 'should have a collection of tools', ->
      expect(@dashboard.attributes).to.have.property('tools').and.be.an.instanceof(Tools)

  describe 'Properties', ->
    beforeEach ->
      @dashboard = new Dashboard

    it 'should have a urlRoot property', ->
      expect(@dashboard).to.have.property('urlRoot').and.equal('/dashboard')

  describe '#parse', ->
    it 'should return a new Tools object as for the tools attribute', ->
      dashboard = new Dashboard
      dashboard.parse(JSON.stringify(responseJson))
      expect(dashboard.attributes).to.have.property('tools').and.be.an.instanceof(Tools)
