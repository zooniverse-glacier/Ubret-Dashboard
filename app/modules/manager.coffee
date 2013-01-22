class UbretManager
  constructor: ->
    @data = []

  save: (key, data) =>
    @data[key] = data

  set: (key, data) => @save(key, data)

  get: (key) =>
    if @data[key] then @data[key] else false

  delete: (key) =>
    delete @data[key]


module.exports = new UbretManager()