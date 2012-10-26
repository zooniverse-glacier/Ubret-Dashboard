require('lib/setup')

Api     = require 'zooniverse/lib/api'
Config  = require 'lib/config'

Stack = require 'controllers/dashboard_stack'
Main  = require 'controllers/Main'

class App extends Spine.Controller
  constructor: ->
    super
    Api.init host: Config.apiHost
    # new Main({el: "body"})

    setup = new Stack()
    Spine.Route.setup()

preload = (image) ->
  img = new Image
  img.src = image

$ ->
  preload '/css/images/marker-icon.png'
  preload '/css/images/marker-icon-orange.png'

module.exports = App