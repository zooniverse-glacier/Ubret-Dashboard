BaseView = require 'views/base_view'

class MapSettings extends BaseView
  className: 'map-settings'
  template: require 'views/templates/settings/map_settings'

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
    @model.get('settings').set 'spectrum', 'visible' if typeof @model.get('settings').get('spectrum') is 'undefined'

  render: =>
    curSpectrum = @model.get('settings').get('spectrum')
    console.log curSpectrum
    @$el.html @template({curSpectrum: curSpectrum, spectra: @spectra})
    @

  changeSpectrum: (e) =>
    spectrum = e.currentTarget.value
    @model.tool.settings({spectrum: spectrum}).start()

module.exports = MapSettings