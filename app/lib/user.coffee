class User extends Backbone.Events
  @current: null
  @incomingLocation: "#/my_dashboards"
  @manager: require('modules/manager')

  @login: ({username, password}) =>
    url = "#{@manager.api()}/login?username=#{encodeURIComponent(username)}&password=#{encodeURIComponent(password)}&callback=?"
    login = $.getJSON(url)
    login.then @createUser, @networkError
    login

  @logout: =>
    url = "#{@manager.api()}/logout?callback=?"
    logout = $.getJSON(url)
    logout.then => 
      User.current = null
      User.trigger 'sign-out'
    logout

  @currentUser: =>
    url = "#{@manager.api()}/current_user?callback=?"
    current = $.getJSON(url)
    current.then @createUser, @networkError
    current

  @signup: ({username, password, email}) =>
    url = "#{@manager.api}/signup?username=#{username}&password=#{password}&email=#{email}&callback=?"
    signup = $.getJSON(url)
    signup.then @createUser, @networkError
    signup

  @createUser: (response) =>
    if response.success
      delete response.success
      User.current = new User response
      User.trigger 'sign-in'
    else
      User.current = null
      User.trigger 'sign-in-error', response.message

  @networkError: =>
    User.trigger 'sign-in-error', "Network Error"

  manager: require 'modules/manager'

  constructor: (options) ->
    _.extend @, Backbone.Events
    @name = options.name
    @id = options.id
    @apiToken = options.api_key
    @dashboards = new Backbone.Collection
    @collections = new require('collections/talk_collections')([], {user: @name})

  getDashboards: =>
    url = "#{User.manager.api()}/dashboards"
    $.ajax 
      url: url
      type: 'GET'
      crossDomain: true
      contentType: 'application/json'
      dataType: 'json'
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'Authorization', "Basic #{btoa("#{@name}:#{@apiToken}")}"
      success: (response) =>
        @dashboards.reset response
        @trigger 'loaded-dashboards'

  removeDashboard: (id, cb) =>
    url = "#{User.manager.api()}/dashboards/#{id}"
    $.ajax 
      url: url
      type: 'DELETE'
      crossDomain: true
      cache: false
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'Authorization', "Basic #{btoa("#{@name}:#{@apiToken}")}"
      success: (response) => cb response

  basicAuth: =>
    "Basic #{btoa("#{@name}:#{@apiToken}")}"

module.exports = User