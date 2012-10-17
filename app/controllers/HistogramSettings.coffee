Spine = require 'spine'

class HistogramSettings extends Spine.Controller

  constructor: ->
    super
    console.log 'ect'
    @tool.bind 'data-received', @buildOptions

  events:
    'change .var' : 'setVariable'

  template: require 'views/histogram_settings'

  render: =>
    @html @template(@)

  buildOptions: =>
    options = new Array
    optionsTmpl = require 'views/histogram_options_settings'

    @tool.extractKeys @tool.data[0]
    for key in @tool.keys
      prettyKey = @tool.prettyKey key
      options.push optionsTmpl({ key, prettyKey })

    @options = options.join '\n' 
    @render()

  setVariable: (e) =>
    @tool.setVariable $(e.currentTarget).val()

module.exports = HistogramSettings