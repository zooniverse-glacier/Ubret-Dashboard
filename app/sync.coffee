corsSync = (method, model, options) ->
  baseUrl = if location.hostname is 'localhost' then "http://localhost:3000" else "https://spelunker.herokuapp.com"
  options.url = baseUrl + _.result(model, 'url')
  options.crossDomain = true
  options.xhrFields = {withCredentials: true}

  return Backbone.sync(method, model, options)

module.exports = corsSync