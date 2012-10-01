Spine = require 'spine'

class ScatterplotSettings extends Spine.Controller
  constructor: ->
    super
    @tool.bind 'data-received', @buildOptions

  events:
    'change .x-var' : 'setXVar'
    'change .y-var' : 'setYVar'

  template: require 'views/scatterplot_settings'

  render: =>
    @append @template(@)

  buildOptions: =>
    options = new Array
    optionsTmpl = require 'views/scatterplot_options_settings'

    keys = @tool.extractKeys @tool.data[0]
    


  
