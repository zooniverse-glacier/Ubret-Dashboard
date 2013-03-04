Login = require 'views/login'

describe "Login", ->
  beforeEach ->
    @login = new Login

  describe '#render', ->
    it 'should render the template', ->
      htmlSpy = sinon.spy(@login.$el, 'html')
      tempSpy = sinon.spy(@login, 'template')
      @login.render()
      expect(htmlSpy).to.have.been.called
      expect(tempSpy).to.have.been.called

    context "user is logged out", ->
      it 'should remove the logged-in class', ->
        @login.user.current = null
        @login.render()
        expect(@login.$el).to.not.have.class 'logged-in'

    context "user is logged in", ->
      it 'should add the logged-in class', ->
        @login.user.current = {name: "edpaget!"}
        @login.render()
        expect(@login.$el).to.have.class 'logged-in'
        @login.user.current = null

  describe '#logout', ->
    it 'should call the user logout method', ->
      e = {preventDefault: -> 'noop'}
      logoutSpy = sinon.stub(@login.user, 'logout')
      @login.logout(e)
      expect(logoutSpy).to.have.been.called

  describe '#showError', ->
    it 'should disply the text of the error', ->
      error = "Username Taken"
      @login.render()
      @login.showError(error)
      expect(@login.$('.error')).to.have.text "Username Taken"
      expect(@login.$('.error')).to.not.have.css "display", "none"

  describe "#onKeyPress", ->
    beforeEach ->
      @loginSpy = sinon.stub(@login, "login")

    context "Key is not enter", ->
      it 'should noop', ->
        e = {keyCode: 14}
        @login.onKeyPress e
        expect(@loginSpy).to.not.have.been.called

    context "Key is enter", ->
      it 'should call login', ->
        e = {keyCode: 13}
        @login.onKeyPress e
        expect(@loginSpy).to.have.been.called

  describe '#login', ->
    it 'should call the login method on user', ->
      loginSpy = sinon.stub(@login.user, 'login')
      @login.render()
      @login.$('input[name="username"]').val("ed")
      @login.$('input[name="password"]').val("password")
      @login.login()
      expect(loginSpy).to.have.been.calledWith({username: "ed", password: "password"})
