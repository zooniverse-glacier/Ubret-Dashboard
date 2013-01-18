User = require 'user'

ouroborosSync = (method, model, options) ->
  baseURL = if location.port < 1024 then "https://api.zooniverse.org" else "https://dev.zooniverse.org"
  options.url = baseURL + _.result(model, 'url')
  options.crossDomain = true
  options.xhrFields = {withCredentials: true}
  options.beforeSend = (xhr) ->
    xhr.setRequestHeader 'Authorization', "Basic #{btoa("#{User.current.name}:#{User.current.apiToken}")}"

  return Backbone.sync(method, model, options)

module.exports = ouroborosSync
