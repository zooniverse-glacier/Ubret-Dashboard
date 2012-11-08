DashboardView = require 'views/dashboard'

describe 'Dashboard', ->
  it 'should be defined', ->
    expect(DashboardView).to.be.ok

  it 'should be instanitable', ->
    dashboard = new DashboardView
    expect(dashboard).to.be.ok

  describe 'instantiation', ->
    beforeEach ->
      @dashboard = new DashboardView

    it 'should create a div', ->
      expect(@dashboard.el.nodeName).to.equal('DIV')

    it 'should have class dashboard', ->
      expect(@dashboard.$el).to.have.class('dashboard')

  describe '#render', ->
    beforeEach ->
      @dashboard = new DashboardView
      @dashboardAppend = sinon.spy(@dashboard.$el, 'append')

      @toolWindowView = new Backbone.View()
      @toolRender = sinon.spy(@toolWindowView, 'render')

      @toolWindowStub = sinon.stub().returns(@toolWindowView) 
      @dashboard._setToolWindow(@toolWindowStub)

      @tool1 = new Backbone.Model { id: 1 }
      @tool2 = new Backbone.Model { id: 2 }
      @tool3 = new Backbone.Model { id: 3 }
      @tools = new Backbone.Collection [@tool1, @tool2, @tool3]
      @dashboard.model = new Backbone.Model
        id: 1
        name: "New Dashboard"
        tools: @tools
      @dashboard.render()

    it 'should create a tool window for each tool in tools collection', ->
      expect(@toolWindowStub).to.have.been.calledThrice
      expect(@toolWindowStub).to.have.been.calledWith({model: @tool1, collection: @tools})
      expect(@toolWindowStub).to.have.been.calledWith({model: @tool2, collection: @tools})
      expect(@toolWindowStub).to.have.been.calledWith({model: @tool3, collection: @tools})

    it 'should render the new windows', ->
      expect(@toolRender).to.have.been.calledThrice

  describe '#addTool', ->
    beforeEach ->
      @dashboard = new DashboardView 
        model: new Backbone.Model 
          tools: new Backbone.Collection [ 
            name: 'test'
            channel: 'test1'
          ,
            name: 'test2'
            channel: 'testagain'
          ]
      @toolWindowStub = sinon.stub(@dashboard, 'createToolWindow')
      @pubSpy = sinon.spy(Backbone.Mediator, 'publish')
      @dashboard.addTool()

    afterEach ->
      Backbone.Mediator.publish.restore()

    it 'should pass the most recent tool object to the createToolWindow function', ->
      expect(@toolWindowStub).to.have.been.called

    it 'should send an updated list of tool/channel pairs', ->
      expect(@pubSpy).to.have.been.calledWith('all-tools', 
        [{name: 'test', channel: 'test1'}, {name: 'test2', channel: 'testagain'}])


