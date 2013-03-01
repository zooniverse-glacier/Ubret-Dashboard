AppHeader = require 'views/app_header'

describe "App Header", ->
  beforeEach ->
    @appHeader = new AppHeader

  it 'should be instantiable', ->
    expect(@appHeader).to.be.defined

  it 'should have a login bar', ->
    expect(@appHeader).to.have.property('login')
      .and.be.an.instanceof(require('views/login'))

  describe '#isForkable', ->
    it 'should be forkable when on a dashboard url', ->
      location.hash = "#/dashboards/2"
      expect(@appHeader.isForkable()).to.be.true
      location.hash = ""

  describe 'event handlers', ->
    beforeEach ->
      @renderSpy = sinon.stub(@appHeader, 'render')
      @pubSpy = sinon.stub(Backbone.Mediator, 'publish')

    afterEach ->
      @renderSpy.restore()
      @pubSpy.restore()

    describe '#onViewCurrent', ->
      it 'should set active and call render', ->
        @appHeader.onViewCurrent()
        expect(@appHeader).to.have.property('active')
          .and.equal('current')
        expect(@renderSpy).to.have.been.called

    describe '#onViewSaved', ->
      it 'should set active and call render', ->
        @appHeader.onViewSaved()
        expect(@appHeader).to.have.property('active')
          .and.equal('saved')
        expect(@renderSpy).to.have.been.called

    describe '#onViewMyData', ->
      it 'should set active and call render', ->
        @appHeader.onViewMyData()
        expect(@appHeader).to.have.property('active')
          .and.equal('mydata')
        expect(@renderSpy).to.have.been.called

    describe '#updateLink', ->
      it 'should set the dashId to the dashboard\'s id', ->
        @appHeader.updateLink({id: 1})
        expect(@appHeader).to.have.property('dashId')
          .and.equal(1)
        expect(@renderSpy).to.have.been.called

    describe '#onCreateDashboard', ->
      it 'should publish a message over Backbone Mediator', ->
        @appHeader.onCreateDashboard()
        expect(@pubSpy).to.have.been.calledWith('dashboard:create')

    describe '#forkDashboard', ->
      it 'should publish a message over Backbone Mediator', ->
        @appHeader.forkDashboard()
        expect(@pubSpy).to.have.been.calledWith('dashboard:fork')

  describe '#render', ->
    it 'should render the template', ->
      templateSpy = sinon.spy(@appHeader, 'template')
      htmlSpy = sinon.spy(@appHeader.$el, 'html')
      @appHeader.render()
      expect(templateSpy).to.have.been.called
      expect(htmlSpy).to.have.been.called

    it 'should set the active view', ->
      @appHeader.active = 'current'
      @appHeader.render()
      expect(@appHeader.$('li a.current')).to.have.class 'active'
      @appHeader.active = 'saved'
      @appHeader.render()
      expect(@appHeader.$('li a.my-dashboards')).to.have.class 'active'
      @appHeader.active = 'mydata'
      @appHeader.render()
      expect(@appHeader.$('li a.my-data')).to.have.class 'active'

    context "when a dashId is defined", ->
      it 'should set the href of .current to dashId', ->
        @appHeader.dashId = 1
        @appHeader.render()
        expect(@appHeader.$('.current')).to.have.attr('href', "/#/dashboards/1")

    context "when a user is not logged in", ->
      beforeEach ->
        @appHeader.user.current = null

      it 'should disable create dashboard', ->
        @appHeader.render()
        expect(@appHeader.$('.create-dashboard')).to.have.attr('disabled', 'disabled')
    
    context "when a user is logged in", ->
      beforeEach ->
        @appHeader.user.current = "ANYTHING"

      it 'should remove the disabled attr from create dashboard', ->
        @appHeader.render()
        expect(@appHeader.$('.create-dashboard')).to.not.have.attr('disabled')

      it 'should show fork dashboard when forkable', ->
        location.hash = "/#/dashboards/1"
        @appHeader.render()
        expect(@appHeader.$('.fork-dashboard')).to.not.have.css('display', 'none')
        location.hash = ""

      it 'should hide fork dashboord when not forkable', ->
        @appHeader.render()
        expect(@appHeader.$('.fork-dashboard')).to.be.hidden
