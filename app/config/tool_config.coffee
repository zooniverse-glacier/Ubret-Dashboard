settings = 
  data: require 'views/settings/data'
  graph: require 'views/settings/graph'
  bins: require 'views/settings/bins'
  key: require 'views/settings/key'
  map: require 'views/settings/map'
  subject: require 'views/settings/subject'
  spectra_legend: require 'views/settings/spectra_legend'
  spacewarp_viewer: require 'views/settings/spacewarp_viewer'

module.exports = 
  "Histogram" : 
    settings: [settings.data, settings.graph, settings.bins]
    defaults: 
      axis2: 'Count'
      color: '#0172E6'
      selectionColor: '#CD3E20'
  "Scatterplot" : 
    settings: [settings.data, settings.graph]
    defaults:
      color: '#0172E6'
      selectionColor: '#CD3E20'
  "Statistics" : 
    settings: [settings.data, settings.key]
    height: 284
    width: 304
    locked: 'perma'
  "Spectra" : 
    settings: [settings.data, settings.subject, settings.spectra_legend]
    titleBarControls: true
    defaults: 
      bestFitLine: 'show'
      fluxLine: 'show'
      emissionLines: 'show'
      axis1: 'Wavelengths (angstroms)'
      axis2: 'Flux (1E-17 erg/cm^2/s/Ang)'
      currentPage: 0
  "SubjectViewer" : 
    settings: [settings.data, settings.subject]
    defaults: {currentPage: 0}
    titleBarControls: true
  "Mapper" : 
    settings: [settings.data, settings.map]
  "Table" : 
    settings: [settings.data, settings.subject]
    defaults: {sortOrder: 'top', currentPage: 0, sortColumn: 'uid'}
    titleBarControls: true
  "SpacewarpViewer" : 
    settings: [settings.data, settings.spacewarp_viewer]

