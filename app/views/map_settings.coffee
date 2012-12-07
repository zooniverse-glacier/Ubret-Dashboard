BaseView = require 'views/base_view'

class MapSettings extends BaseView
  className: 'map-settings'
  template: require './templates/map_settings'

  spectra: 
    infrared: 'Infrared'
    xray: 'X-Ray'
    gamma: 'Gamma Ray'
    microwave: 'Microwave'
    visible: 'Visible'
    radio: 'Radio'
    halpha: 'H-Alpha'

  events:
    'change select.spectrum' : 'changeSpectrum'

  initialize: ->
    @model.get('settings').set 'spectrum', 'visible'

  render: ->
    curSpectrum = @model.get('settings').get('spectrum')
    @$el.html @template({curSpectrum: curSpectrum, spectra: @spectra})
    @

  changeSpectrum: (e) ->
    spectrum = e.target.value
    @model.get('settings').set  'specturm', spectrum

module.exports = MapSettings