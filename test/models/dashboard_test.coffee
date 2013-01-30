Dashboard = require 'models/dashboard'

describe 'Dashboard', ->
  beforeEach ->
    @dashboard = new Dashboard

  it 'should be instantiable', ->
    expect(@dashboard).to.be.defined

  it 'should have a tools collection ready and have some defaults', ->
    expect(@dashboard.attributes).to.have.property('tools')
    expect(@dashboard.attributes).to.have.property('name')
    expect(@dashboard.attributes).to.have.property('project')

  describe '#createTool', ->
    it 'should create a new tool with the given tool type', ->
      spy = sinon.spy(@dashboard.get('tools'), 'add')
      @dashboard.createTool 'table'
      expect(spy).to.have.been.calledWith({tool_type: 'table'})

  describe '#fork', ->
    # Don't know yet.
