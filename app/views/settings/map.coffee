BaseView = require 'views/base_view'

class MapSettings extends BaseView
  className: 'map-settings'
  template: require 'views/templates/map_settings'

  spectra: 
    infrared: 'Infrared'
    xray: 'X-Ray'
    gamma: 'Gamma Ray'
    microwave: 'Microwave'
    visible: 'Visible'
    radio: 'Radio'
    halpha: 'H-Alpha'

  events:
    'change select.select-spectrum' : 'changeSpectrum'

  initialize: ->
    @model.settings.set 'spectrum', 'visible' if typeof @model.settings.get('spectrum') is 'undefined'

  render: =>
    curSpectrum = @model.settings.get('spectrum')
    @$el.html @template({curSpectrum: curSpectrum, spectra: @spectra})
    @

  changeSpectrum: (e) =>
    spectrum = e.target.value
    @model.settings.set  'spectrum', spectrum

module.exports = MapSettings