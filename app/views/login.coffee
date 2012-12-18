User = require 'user'

class Login extends Backbone.View
  tagName: 'div'
  className: 'login'
  template: require './templates/login_bar'

  events: 
    'click button.login' : 'login'
    'click a.signout' : 'logout'

  initialize: ->
    User.on 'sign-in', @render
    User.on 'sign-out', @render
    User.on 'sign-in-error', @showError

  render: =>
    @$el.html @template(User.current)
    if User.current isnt null
      @$el.addClass 'logged-in'
    else
      @$el.removeClass 'logged-in'
    @

  logout: (e) =>
    e.preventDefault()
    User.logout()

  showError: (error) =>
    @$('.error').text(error).show()

  login: (e) =>
    username = @$('input[name="username"]').val()
    password = @$('input[name="password"]').val()

    User.login
      username: username
      password: password

module.exports = Login