class User extends Backbone.Events
  @current: null
  @incomingLocation: "#/my_dashboards"
  @manager: require('modules/manager')

  @login: (cred) =>
    login = zooniverse.models.User.login(cred).then @createUser, @networkError
    login

  @logout: =>
    logout = zooniverse.models.User.logout()
    logout.then => 
      User.current = null
      User.trigger 'sign-out'
    logout

  @currentUser: =>
    current = zooniverse.models.User.fetch()
    current.then @createUser, @networkError
    current

  @signup: (user) =>
    signup = zooniverse.models.User.signup(user)
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
    TalkCollection = require('collections/talk_collections')
    @collections = new TalkCollection([], {user: @name})

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