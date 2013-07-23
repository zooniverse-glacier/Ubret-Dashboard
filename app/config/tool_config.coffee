settings = 
  fql: require 'views/settings/fql'
  data: require 'views/settings/data'
  graph: require 'views/settings/graph'
  bins: require 'views/settings/bins'
  key: require 'views/settings/key'
  map: require 'views/settings/map'
  subject: require 'views/settings/subject'
  spectra_legend: require 'views/settings/spectra_legend'
  spacewarp_viewer: require 'views/settings/spacewarp_viewer'
  zooniverse: require 'views/settings/zooniverse_data'
  image_player: require 'views/settings/image_player'
  download_data: require 'views/settings/download_data'


module.exports = 
  "BarGraph":
    settings: [settings.data, settings.graph]
    defaults:
      axis2: 'Count'
      color: '#0172E6'
  "ImageGallery":
    settings: [settings.data, settings.subject]
    defaults: {currentPage: 0}
    titleBarControls: true
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
    locked: true
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
    defaults: {spectrum: 'visible'}
  "Table" : 
    settings: [settings.data, settings.subject, settings.fql]
    defaults: {sortOrder: 'top', currentPage: 0, sortColumn: 'uid'}
    titleBarControls: true
  "SpacewarpViewer" : 
    settings: [settings.data, settings.spacewarp_viewer, settings.subject]
    defaults: {
      currentPage: 0,
      alpha: 0.09,
      q: 1.0,
      scales: [0.4, 0.6, 1.7],
      stretch: 'linear',
      band: 'gri',
      sliderMin: 0,
      sliderMax: 1000
    }
    titleBarControls: true
    width: 680
    height: 473
  "Zooniverse" :
    settings: [settings.zooniverse, settings.download_data]
    data_source: {source_type: "zooniverse", params: [{key: 'zoo_ids', val: []}]}
  "Sky Server" :
    settings: [settings.download_data]
    data_source: {source_type: "external", source_id: "sky_server"}
  "Quench" :
    settings: [settings.download_data]
    settings_active: false
    data_source: {source_type: 'quench'}
    height: 150
    width: 300
  "ColorMagnitudeChart":
    settings: [settings.data]
  "Snapshot Serengeti CartoDB":
    settings: [settings.download_data]
    data_source: {source_type: "external", source_id: "serengeti_carto"}
  "ImagePlayer":
    settings: [settings.data, settings.image_player, settings.subject]
    defaults: 
      currentPage: 0
      imageIndex: 0
      isPlaying: false