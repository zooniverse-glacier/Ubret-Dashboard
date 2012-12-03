class User extends Backbone.Events
  @current: null

  @zooniverseUrl: =>
    if location.port > 1024 then "dev" else "api"

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
      User.current = null
      User.trigger 'sign-out'
    logout

  @currentUser: =>
    url = "https://#{@zooniverseUrl()}.zooniverse.org/current_user?callback=?"
    current = $.getJSON(url)
    current.always @createUser
    current.always (response) =>
      User.trigger 'sign-in' if User.current isnt null
    current

  @signup: ({username, password, email}) =>
    url = "https://#{@zooniverseUrl()}.zooniverse.org/signup?username=#{username}&password=#{password}&email=#{email}&callback=?"
    signup = $.getJSON(url)
    signup.always @createUser
    signup.success => User.trigger 'sign-in'
    signup

  @createUser: (response) =>
    User.current = if response.success
      delete response.success
      new User response
    else
      User.trigger 'sign-in-error', response
      null

  constructor: (options) ->
    console.log options
    @name = options.name
    @dashboards = options.dashboards
    @id = options.id

module.exports = User