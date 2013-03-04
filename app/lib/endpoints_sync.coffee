corsSync = (method, model, options) ->
  baseUrl = 'http://spelunker.herokuapp.com'
  options.url = baseUrl + _.result(model, 'url')
  options.crossDomain = true

  return Backbone.sync(method, model, options)

module.exports = corsSync