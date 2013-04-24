class Login extends Backbone.View
  tagName: 'div'
  className: 'login'
  template: require './templates/login_bar'
  user: require 'lib/user'

  events:
    'click button.login' : 'login'
    'click a.signout' : 'logout'
    'keypress': 'onKeyPress'

  initialize: ->
    @user.on
      'sign-in': @render
      'sign-out': @render
      'sign-in-error': @showError

  render: =>
    @$el.html @template(@user.current)
    if @user.current isnt null
      @$el.addClass 'logged-in'
    else
      @$el.removeClass 'logged-in'
    @

  logout: (e) =>
    e.preventDefault()
    @user.logout()

  showError: (error) =>
    console.log error 
    @$('.error').text(error).show()

  onKeyPress: (e) =>
    if e.keyCode is 13
      @login()

  login: =>
    username = @$('input[name="username"]').val()
    password = @$('input[name="password"]').val()

    @user.login
      password: password
      username: username

module.exports = Login