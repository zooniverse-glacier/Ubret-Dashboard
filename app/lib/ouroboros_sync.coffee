User = require 'lib/user'
Manager = require 'modules/manager'

ouroborosSync = (method, model, options) ->
  baseURL = Manager.api()
  unless options.url
    options.url = baseURL + _.result(model, 'url') 
  options.crossDomain = true
  if User.current?
    options.beforeSend = (xhr) ->
      xhr.setRequestHeader 'Authorization', User.current.basicAuth()
  
  return Backbone.sync(method, model, options)

module.exports = ouroborosSync
