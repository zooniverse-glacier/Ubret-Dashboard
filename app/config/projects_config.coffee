Projects =
  galaxy_zoo: 
    name: 'Galaxy Zoo'
    talk: true
    sources: ["Zooniverse", "Sky Server"]
    tools: ["Histogram", "Scatterplot", "Mapper", "Statistics", "SubjectViewer", "Spectra", "Table", "ColorMagnitudeChart"]
    defaults: ["Table", "SubjectViewer"]

  galaxy_zoo_starburst:
    name: 'Quench'
    talk: true
    sources: ["Quench", "Zooniverse", "Sky Server"]
    tools: ["BarGraph", "Histogram", "Scatterplot", "Mapper", "Statistics", "SubjectViewer", "Spectra", "Table", "ColorMagnitudeChart"]
    defaults: ["Table", "SubjectViewer"]

  clusters:
    name: "Classroom Clusters",
    talk: false
    sources: ["Cluster"]
    tools: ["BarGraph", "Histogram", "Scatterplot", "Mapper", "Statistics",  "Spectra", "Table", "ColorMagnitudeChart"]
    defaults: ["Table"]

  spacewarp: 
    name: 'Space Warps'
    talk: true
    sources: ["Zooniverse"]
    tools: ["SpacewarpViewer"]
    defaults: [ "SpacewarpViewer"]
    
  serengeti: 
    name: 'Snapshot Serengeti'
    talk: true
    sources: ["Zooniverse", "Snapshot Serengeti"]
    tools: ["Statistics", "SubjectViewer", "Table", "BarGraph", "ImageGallery", "ImagePlayer"]
    defaults: ["SubjectViewer"]
    
module.exports = Projects
