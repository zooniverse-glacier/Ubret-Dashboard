BaseView = require 'views/base_view'

class MapSettings extends BaseView
  className: 'map-settings'
  template: require 'views/templates/settings/map'

  spectra: 
    radio: 'Radio'
    microwave: 'Microwave'
    infrared: 'Infrared'
    visible: 'Visible'
    halpha: 'H-Alpha'
    xray: 'X-Ray'
    gamma: 'Gamma Ray'

  events:
    'change select.select-spectrum' : 'changeSpectrum'

  initialize: ->
    @model.get('settings').set 'spectrum', 'visible' if typeof @model.get('settings').get('spectrum') is 'undefined'

  render: =>
    curSpectrum = @model.get('settings').get('spectrum')
    @$el.html @template({curSpectrum: curSpectrum, spectra: @spectra})
    @

  changeSpectrum: (e) =>
    spectrum = e.currentTarget.value
    @model.tool.settings({spectrum: spectrum})

module.exports = MapSettings