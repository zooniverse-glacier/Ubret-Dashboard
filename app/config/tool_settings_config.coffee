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
    settings: [settings.data, settings.graph, settings.bin]
  "Scatterplot" : 
    settings: [settings.data, settings.graph]
  "Statistics" : 
    settings: [settings.data, settings.key]
  "Spectra" : 
    settings: [settings.data, settings.subject, settings.spectra_legend]
    titleBarControls: true
  "SubjectViewer" : 
    settings: [settings.data, settings.subject]
    titleBarControls: true
  "Mapper" : 
    settings: [settings.data, settings.map]
  "Table" : 
    settings: [settings.data, settings.subject]
    titleBarControls: true
  "SpacewarpViewer" : 
    settings: [settings.data, settings.spacewarp_viewer]

