_ = require 'underscore/underscore'
Spine = require 'spine'

Source = require 'models/Source'

class DataSettings extends Spine.Controller
  events:
    'click .data-sources li'    : 'onDataSourceSelection'
    'click button[name="fetch"]': 'fetchData'

  elements: 
    '.source-choices'           : 'sourceData'
    '.data-points'              : 'dataPoints'
    '.submit'                   : 'submit'
    'input[name="params"]'      : 'params'
    'input[name="identifier"]'  : 'identifier'
    '.source-data-box'          : 'sourceDataBox'

  template: require('views/data_settings')

  constructor: ->
    super
    @bindOptions = new Object()

  render: =>
    @html @template(@)

  onDataSourceSelection: (e) =>
    @sourceItem = $(e.currentTarget)
    @sourceItem.addClass 'selected'
    @sourceItem.siblings().removeClass 'selected'

    @source = @sourceItem.data('source')

    @sourceData.empty()

    if @source is 'api'
      @sourceData.append(require('views/data_settings_sources')(@))
      @dataPoints.show()
    else
      @sourceData.append(require('views/data_settings_channel')(@))
      @dataPoints.hide()

    @sourceDataBox.show()
    @submit.show()

  fetchData: (e) =>
    e.preventDefault()
    source = @sourceData.val()
    
    if source is 'SDSS3Spectral'
      params = @identifier.val()
    else
      unless @source == 'channel'
        params = @params.val()

    dataSource = Source[source]
    source = dataSource if @source is 'api'
    @bindTool @source, source, params

  setBindOptions: (source, params='') =>
    @bindOptions = {
        source: source
      }

    if params
      @bindOptions = _.extend @bindOptions, {type: 'api', params: params}
    else
      @bindOptions = _.extend @bindOptions, {type: 'channel', process: @process}

  bindTool: (source_type, source, params='') =>
    @setBindOptions source, params
    if @bindOptions.type is 'api'
      @getDataSource source, params
    else if @bindOptions.type is 'channel'
      @tool.subscribe source, @process
    else
      console.log 'err'

  getDataSource: (source, params) =>
    source.fetch(params).always =>
      @tool.receiveData source.lastFetch

module.exports = DataSettings
