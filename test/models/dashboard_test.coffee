Dashboard = require 'models/dashboard'

describe 'Dashboard', ->
  beforeEach ->
    @dashboard = new Dashboard

  it 'should be instantiable', ->
    expect(@dashboard).to.be.defined

  describe '#createTool', ->
    it 'should create a new tool with the given tool type', ->
      spy = sinon.spy(@dashboard.get('tools'), 'add')
      @dashboard.createTool 'table'
      expect(spy).to.have.been.calledWith({type: 'table'})
