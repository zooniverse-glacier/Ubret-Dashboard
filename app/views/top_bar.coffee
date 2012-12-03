User = require 'user'

class TopBar extends Backbone.View
  tag: 'div'
  id: 'zoo-top-bar'
  template: require './templates/top_bar'

  initialize: ->
    User.on 'sign-in', @render
    User.on 'sign-in-error', @render
    User.on 'sign-out', @render

    User.currentUser().always =>
      @toggleVisible() if User.current is null

  events:
    'click button[name="signout"]' : 'onSignOut'
    'click button[name="login"]' : 'onLogIn'
    'click button[name="signup"]' : 'onSignUp'
    'click a.top-bar-button' : 'toggleVisible'

  render: =>
    @$el.html @template()
    @

  toggleVisible: (e) =>
    e?.preventDefault()
    @$el.toggleClass 'active'

  onLogIn: =>
    login =
      username: @$('input[name="username"]').val()
      password: @$('input[name="password"]').val()

    User.login login

  onSignOut: =>
    User.logout()

  onSignUp: =>
    console.log 'sign-up'


module.exports = TopBar