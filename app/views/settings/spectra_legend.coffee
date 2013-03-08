BaseView = require 'views/base_view'

class SpectraLegend extends BaseView
  tagName: 'div'
  className:  'spectra-legend'
  template: require 'views/templates/settings/spectra_legend'

  events: 
    'click button.best-fit' : 'toggleBestFit'
    'click button.flux' : 'toggleFlux'
    'click button.emissions' : 'toggleEmissions'

  render: =>
    @$el.html @template(@model.get('settings').toJSON())
    @

  toggleBestFit: =>
    @model.tool
      .settings({bestFitLine: @toggle(@model.get('settings').get('bestFitLine'))})

  toggleFlux: =>
    @model.tool
      .settings({fluxLine: @toggle(@model.get('settings').get('fluxLine'))})

  toggleEmissions: =>
    @model.tool
      .settings({emissionLines: @toggle(@model.get('settings').get('emissionLines'))})

  toggle: (value) =>
    if value is 'show' then 'hide' else 'show'

module.exports = SpectraLegend