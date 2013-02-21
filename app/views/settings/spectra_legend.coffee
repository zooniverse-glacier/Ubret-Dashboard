BaseView = require 'views/base_view'

class SpectraLegend extends BaseView
  tagName: 'div'
  className:  'spectra-legend'
  template: require 'views/templates/settings/spectra_legend'

  events: 
    'click button.best-fit' : 'toggleBestFit'
    'click button.flux' : 'toggleFlux'
    'click button.emissions' : 'toggleEmissions'

  initialize: ->
    for line in ['bestFitLine', 'fluxLine', 'emissionLines']
      unless @model.get('settings').get(line)?
        @model.get('settings').set line, 'show'

  render: =>
    @$el.html @template(@model.get('settings').toJSON())
    @

  toggleBestFit: =>
    @model.tool
      .settings({bestFitLine: @toggle(@model.get('settings').get('bestFitLine'))})
      .start()

  toggleFlux: =>
    @model.tool
      .settings({fluxLine: @toggle(@model.get('settings').get('fluxLine'))})
      .start()

  toggleEmissions: =>
    @model.tool
      .settings({emissionLines: @toggle(@model.get('settings').get('emissionLines'))})
      .start()

  toggle: (value) =>
    if value is 'show' then 'hide' else 'show'

module.exports = SpectraLegend