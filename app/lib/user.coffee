class User extends Backbone.Events
  @current: null
  @incomingLocation: "#/dashboards/galaxy_zoo"
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
    @prefs = options.preferences
    @id = options.id
    @apiToken = options.api_key
    @dashboards = new Backbone.Collection
    TalkCollection = require('collections/talk_collections')
    @collections = new TalkCollection([], {user: @name})
    @ajaxOpts = 
      crossDomain: true
      dataType: 'json'
      contentType: 'application/json; charset=UTF-8'
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'Authorization', @basicAuth()

  getDashboards: =>
    url = "#{User.manager.api()}/dashboards"
    opts = _.extend {url: url, type: 'GET'}, @ajaxOpts
    $.ajax(opts).then (response) =>
      @dashboards.reset response
      @trigger 'loaded-dashboards'

  removeDashboard: (id, cb) =>
    url = "#{User.manager.api()}/dashboards/#{id}"
    opts = _.extend {url: url, type: 'DELETE', cache: false}, @ajaxOpts
    $.ajax(opts).then (response) => cb response

  finishTutorial: =>
    url = @manager.api() + "/users/preferences"
    opts = 
      url: url
      type: 'PUT'
      data: JSON.stringify({key: "dashboard.tutorial", value: true})
    opts = _.extend(opts, @ajaxOpts)
    $.ajax(opts).then (response) => console.log response

  basicAuth: =>
    "Basic " + btoa(@name + ":" + @apiToken)

  preferences: (projectID) =>
    @prefs[projectID]?.dashboard

module.exports = User