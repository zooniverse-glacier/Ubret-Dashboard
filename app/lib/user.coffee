class User extends Backbone.Events
  @current: null

  @apiUrl: =>
    if parseInt(location.port) < 1024
      "https://dev.zooniverse.org"
    else if parseInt(location.port) is 3333
      "http://localhost:3000"
    else
      "https://dev.zooniverse.org"

  @login: ({username, password}) =>
    url = "#{@apiUrl()}/login?username=#{username}&password=#{password}&callback=?"
    login = $.getJSON(url)
    login.always @createUser
    login.done => User.trigger 'sign-in'
    login

  @logout: =>
    url = "#{@apiUrl()}/logout?callback=?"
    logout = $.getJSON(url)
    logout.done => 
      User.current = null
      User.trigger 'sign-out'
    logout

  @currentUser: =>
    url = "#{@apiUrl()}/current_user?callback=?"
    current = $.getJSON(url)
    current.always @createUser
    current.always (response) =>
      User.trigger 'sign-in' if User.current isnt null
    current

  @signup: ({username, password, email}) =>
    url = "#{@apiUrl}/signup?username=#{username}&password=#{password}&email=#{email}&callback=?"
    signup = $.getJSON(url)
    signup.always @createUser
    signup.done => User.trigger 'sign-in'
    signup

  @createUser: (response) =>
    User.current = if response.success
      delete response.success
      new User response
    else
      User.trigger 'sign-in-error', response.message
      null

  constructor: (options) ->
    _.extend @, Backbone.Events
    @name = options.name
    @id = options.id
    @apiToken = options.api_key

  getDashboards: =>
    url = "#{User.apiUrl()}/dashboards"
    $.ajax 
      url: url
      type: 'GET'
      crossDomain: true
      contentType: 'application/json'
      dataType: 'json'
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'Authorization', "Basic #{btoa("#{@name}:#{@apiToken}")}"
      success: (response) =>
        @dashboards = new Backbone.Collection response
        @trigger 'loaded-dashboards'

  removeDashboard: (id, cb) =>
    url = "#{User.apiUrl()}/dashboards/#{id}"
    $.ajax 
      url: url
      type: 'DELETE'
      crossDomain: true
      cache: false
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'Authorization', "Basic #{btoa("#{@name}:#{@apiToken}")}"
      success: (response) => cb response

module.exports = User