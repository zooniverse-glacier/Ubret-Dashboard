Window = require 'views/window'

class MpcorbWindow extends Window
  className: 'tool-window quench-window data-source-window'
  mpcorbTemplate: require './templates/mpcorb_window'

  events:
    'click button' : 'fetchData'

  initialize: ->
    @model.on('change:data_source.search_type', @render, @)

  render: =>
    super
    @$('.container').html @mpcordTemplate()
    if @model.get('data_source.search_type')?
      @$('button').addClass('selected')
  
  fetchData: =>
    @model.set('data_source.search_type', 'mpcorb')

module.exports = MpcorbWindow
