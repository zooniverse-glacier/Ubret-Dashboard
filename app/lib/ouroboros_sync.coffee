User = require 'lib/user'
Manager = require 'modules/manager'

ouroborosSync = (method, model, options) ->
  baseURL = if parseInt(location.port) < 1024 
    "https://api.zooniverse.org" 
  else if parseInt(location.port) is 3333
    "http://localhost:3000"
  else 
    "https://dev.zooniverse.org"
  options.url = baseURL + "/projects/#{Manager.get('project')}" + _.result(model, 'url')
  options.crossDomain = true
  options.beforeSend = (xhr) ->
    xhr.setRequestHeader 'Authorization', "Basic #{btoa("#{User.current.name}:#{User.current.apiToken}")}"
  
  return Backbone.sync(method, model, options)

module.exports = ouroborosSync
