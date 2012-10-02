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
    @html @template(@)

  buildOptions: =>
    options = new Array
    optionsTmpl = require 'views/scatterplot_options_settings'

    @tool.extractKeys @tool.data[0]
    for key in @tool.keys
      prettyKey = @tool.prettyKey key
      options.push optionsTmpl({ key, prettyKey })

    @options = options.join '\n' 
    @render()

  setXVar: (e) =>
    @tool.setXVar $(e.currentTarget).val()

  setYVar: (e) =>
    @tool.setYVar $(e.currentTarget).val()

module.exports = ScatterplotSettings
