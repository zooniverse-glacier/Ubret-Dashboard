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
      @dashboard.createTool 'Table'
      expect(spy).to.have.been.calledWith({tool_type: 'Table'})

  describe '#fork', ->
    beforeEach ->
      @xhr = sinon.useFakeXMLHttpRequest()
      @requests = []
      @xhr.onCreate = (xhr) =>
        @requests.push xhr
      @dashboard.id = 1
      @dashboard.user.current = new Object
      @dashboard.user.current.id = 1
      @dashboard.user.current.apiToken = 2
      @dashboard.fork()

    it 'should have made a request to the server', ->
      expect(@requests).to.have.length(1)
      expect(@requests[0].method).to.be("POST")
      expect(@requests[0].url)
        .to.be("https://dev.zooniverse.org/dashboards/1/fork")



    
