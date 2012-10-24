Spine = require 'spine'

Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'

class GalaxyZoo extends Spine.Model
  @configure 'GalaxyZoo', "image", "magnitude", "ra", "dec",  "zooniverse_id", "petrosian_radius", "survey", "survey_id"

  constructor: ->
    super

  @url: (params) -> @withParams "/projects/galaxy_zoo/groups/50251c3b516bcb6ecb000002/subjects", params

  @withParams: (url = '', params) ->
    url += '?' + $.param(params) if params
    url

  @fetch: (count = 1) ->
    fetcher = Api.get @url(limit: count), @fromJSON 

  @fromJSON: (json) =>
    @lastFetch = new Array
    for result in json
      item = @create
        image: result.location.standard
        magnitdue: result.metadata.magnitude
        ra: result.coords[0]
        dec: result.coords[1]
        zooniverse_id: result.zooniverse_id
        petrosian_radius: result.metadata.petrorad_r
        survey: result.metadata.survey
        survey_id: result.metadata.sdss_id or result.metadata.hubble_id
      @lastFetch.push item

  @newImage: (location) ->
    image = new Image
    image.src = location
    return image


class Interactive extends Spine.Model
  @configure 'Interactive', 'redshift', 'color', 'subject', 'classification', 'counters', 'image', 'zooniverse_id', 'absolute_brightness', 'apparent_brightness', 'absolute_radius'

  @fetch: ({random, limit, user}) =>
    url = @url(random, limit, user)
    fetcher = Api.getJSON url, @fromJSON

  @url: (random, limit, user) =>
    if random
      url = '/user_groups/506a216fd10d240486000002/recents'
    else if user
      url = "/user_groups/#{User.current.user_group_id}/user_recents"
    else
      url = "/user_groups/#{User.current.user_group_id}/recents"

    limit = parseInt(limit) + 5
    if limit isnt 0
      url = url + "?limit=#{limit}"

    return url

  @fromJSON: (json) =>
    @lastFetch = new Array
    for result in json
      if result.recent.subject.metadata.survey is 'sloan'
        item = @create
          counters: result.recent.subject.metadata.counters
          classification: result.recent.user.classification
          image: result.recent.subject.location.standard
          zooniverse_id: result.recent.subject.zooniverse_id
          redshift: result.recent.subject.metadata.redshift
          absolute_brightness: result.recent.subject.metadata.mag?.abs_r
          apparent_brightness: result.recent.subject.metadata.mag?.r
          color: result.recent.subject.metadata.mag?.u - result.recent.subject.metadata.mag?.r
          absolute_radius: result.recent.subject.metadata.absolute_size

        @lastFetch.push item


class SDSS3Spectral extends Spine.Model
  @configure 'SDSS3Spectral', 'ra', 'dec', 'z', 'wavelengths', 'best_fit', 'flux', 'spectralLines'
  
  @spectrumID = /(?:all|sdss|boss)\.\d{3,4}\.5\d{4}\.\d{1,3}\.(?:103|26|104|v5_4_45)?/
  
  @fetch: (sdssid) =>
    match = sdssid.match(SDSS3SpectralData.spectrumID)
    unless match?
      alert 'SDSS Spectral ID is malformed.'
      return null
    
    spectrumUrl = "http://api.sdss3.org/spectrum?id=#{sdssid}&format=json&fields=ra,dec,z,wavelengths,best_fit,flux"
    specLineUrl = "http://api.sdss3.org/spectrumLines?id=#{sdssid}"
    
    return $.when($.ajax(spectrumUrl), $.ajax(specLineUrl)).done (spectrum, lines) =>
      SDSS3SpectralData.fromJSON(spectrum[0], lines)

  @fromJSON: (spectrum, lines) =>
    @lastFetch = new Array
    for key, value of spectrum[0]
      spectralLines = {}
      for line in lines[0][key]
        spectralLines[line.name] = line.wavelength
      spectrum[0][key]['spectralLines'] = spectralLines
      item = @create spectrum[0][key]
      @lastFetch.push item


class SkyServer extends Spine.Model
  @configure 'SkyServer', 'objID', 'specObjID', 'ra', 'dec', 'raErr', 'decErr', 'b', 'l', 'mjd', 'type', 'u_band_magnitude', 'g_band_magnitude', 'r_band_magnitude', 'i_band_magnitude', 'z_band_magnitude', 'err_in_u_band_magnitude', 'err_in_g_band_magnitude', 'err_in_r_band_magnitude', 'err_in_i_band_magnitude', 'err_in_z_band_magnitude', 'petrosian_radius_u', 'petrosian_radius_g', 'petrosian_radius_r', 'petrosian_radius_i', 'petrosian_radius_z', 'extinction_u', 'extinction_g', 'extinction_r', 'extinction_i', 'extinction_z', 'fracDeV_u', 'fracDeV_g', 'fracDeV_r', 'fracDeV_i', 'fracDeV_z', 'zooniverse_id'
  
  @fetch: (count = 1) ->
    count = parseInt count
    count += 1
    params =
      dataType: 'jsonp',
      url: "http://skyserver.herokuapp.com/skyserver/random.json"
      data:
        count: count
      callback: 'givemegalaxies'
      success: @fromJSON
    
    $.ajax(params)

  @fromJSON: (json) =>
    @lastFetch = new Array
    for result in json
      unless result == json[1]
        item = @create
          zooniverse_id: result.objID
          objID: result.objID
          specObjID: result.specObjID
          ra: result.ra
          dec: result.dec
          raErr: result.raErr
          decErr: result.decErr
          b: result.b
          l: result.l
          mjd: result.mjd
          type: result.type
          u_band_magnitude: result.u
          g_band_magnitude: result.g
          r_band_magnitude: result.r
          i_band_magnitude: result.i
          z_band_magnitude: result.z
          err_in_u_band_magnitude: result.err_u
          err_in_g_band_magnitude: result.err_g
          err_in_r_band_magnitude: result.err_r
          err_in_i_band_magnitude: result.err_i
          err_in_z_band_magnitude: result.err_z
          petrosian_radius_u: result.petroR90_u
          petrosian_radius_g: result.petroR90_g
          petrosian_radius_r: result.petroR90_r
          petrosian_radius_i: result.petroR90_i
          petrosian_radius_z: result.petroR90_z
          extinction_u: result.extinction_u
          extinction_g: result.extinction_g
          extinction_r: result.extinction_r
          extinction_i: result.extinction_i
          extinction_z: result.extinction_z
          fracDeV_u: result.fracDeV_u
          fracDeV_g: result.fracDeV_g
          fracDeV_r: result.fracDeV_r
          fracDeV_i: result.fracDeV_i
          fracDeV_z: result.fracDeV_z
        @lastFetch.push item


Source = {
    GalaxyZoo: GalaxyZoo
    SkyServer: SkyServer
    SDSS3Spectral: SDSS3Spectral
    Interactive: Interactive
  }
module.exports = Source

