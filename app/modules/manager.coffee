class UbretManager
  constructor: ->
    @data = { project: 'galaxy_zoo' }

  save: (key, data) =>
    @data[key] = data

  set: (key, data) =>
    @save key, data

  get: (key) =>
    if @data[key] then @data[key] else false

  delete: (key) =>
    delete @data[key]

  baseApi: =>
    if isNaN(parseInt(location.port))
      "https://api.zooniverse.org"
    else if parseInt(location.port) is 3333
      "http://192.168.33.10"
    else if parseInt(location.port) is 3335
      "https://api.zooniverse.org"
    else
      "https://dev.zooniverse.org"
    
  api: =>    
   @baseApi() + "/projects/#{@get('project')}"

module.exports = new UbretManager()