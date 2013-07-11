corsSync = (method, model, options) ->
  options.url = _.result(model, 'url')
  options.crossDomain = true

  return Backbone.sync(method, model, options)

module.exports = corsSync