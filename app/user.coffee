class User extends Backbone.Events
  @zoonverseUrl: =>
    if location.port > 1024 then "dev" else "api"

  @apiUrl: =>
    if location.port > 1024 then "http://localhost:3000/users/" else "https://spelunker.herokuapp.com/users"

  @login: ({username, password}) =>
    url = "https://#{@zooniverseUrl()}.zooniverse.org/login?username=#{username}&password=#{password}&callback=?"
    login = $.getJSON(url)
    login.always @createUser
    login.success => User.trigger 'sign-in'
    login

  @logout: =>
    url = "https://#{@zooniverseUrl()}.zooniverse.org/logout?callback=?"
    logout = $.getJSON(url)
    logout.success =>
      User.current = null if result.success
      User.trigger 'signed-out'
    logout

  @currentUser: =>
    $.ajax
      url: @apiUrl
      dataType: 'json'
      crossDomain: true
      xhrFields:
        withCredentials: true
      success: (response) =>
        User.current = new User response
        User.trigger 'sign-in'
      error: (response) =>
        @currentOuroborosUser()

  @currentOuroborosUser: =>
    url = "https://#{@zooniverseUrl()}.zooniverse.org/current_user?callback=?"
    current = $.getJSON(url)
    current.always @createuser
    current.success => User.trigger 'sign-in'
    current

  @signup: ({username, password, email}) =>
    url = "https://#{@zooniverseUrl()}.zooniverse.org/signup?username=#{username}&password=#{password}&email=#{email}&callback=?"
    signup = $.getJSON(url)
    signup.always @createuser
    signup.success => User.trigger 'sign-in'
    signup

  @createUser: (response) =>
    if response.success
      $.ajax
        url: "#{@apiUrl}/#{response.id}?name=#{response.name}"
        dataType: 'json'
        crossDomain: true
        xhrFields:
          withCredentials: true
        success: (response) ->
          new User response
        error: (response) ->
          User.trigger 'sign-in-error', response
    else
      User.trigger 'sign-in-error', response

  constructor: (options) ->
    @name = options.username
    @dashboards = options.dashboards

module.exports = User