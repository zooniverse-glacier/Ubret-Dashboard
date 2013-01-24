class Recents extends Backbone.Collection
  sync: require 'ouroboros_sync'

  url: '/projects/galaxy_zoo/recents?per_page=10'

  model: require 'models/recent'

  parse: (response) ->
    models = new Array
    for subject in response
      info = subject['subjects'][0]
      model = new Object
      model.uid = info.zooniverse_id
      model.image = info.location.standard
      model.ra = info.coords[0]
      model.dec = info.coords[1]
      model.absolute_size = info.metadata.absolute_size
      model.u = info.metadata.mag.u
      model.g = info.metadata.mag.g
      model.r = info.metadata.mag.r
      model.i = info.metadata.mag.i
      model.z = info.metadata.mag.z
      model.abs_r = info.metadata.mag.abs_r
      model.petrorad_50_r = info.metadata.petrorad_50_r
      model.petrorad_flux = info.metadata.petrorad_flux
      model.petrorad_r = info.metadata.petrorad_r
      model.redshift = info.metadata.redshift
      model.sdss_id = info.metadata.sdss_id
      models.push model
    models


module.exports = Recents