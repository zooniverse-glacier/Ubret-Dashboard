
class UbretManager

  constructor: ->
    @data = []

  save: (key, data) =>
    @data[key] = data

  get: (key) =>
    @data[key]

module.exports = new UbretManager()