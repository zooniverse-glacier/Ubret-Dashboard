BaseView = require 'views/base_view'


class ImagePlayerSettings extends BaseView
  className: 'image-player-settings'
  template: require 'views/templates/settings/image_player'

  events:
    'click button.next'                     : 'next'
    'click button.prev'                     : 'prev'
    'click input[data-action="play-pause"]' : 'onPlayPause'
    'click button[data-action="reset"]'     : 'onReset'
    
    
  initialize: ->
    @page = @model.get('settings').get('currentPage') or 0
  
  render: =>
    @$el.html @template()
    
    opts = @model.tool.opts
    if opts.isPlaying is true
      @$el.find('input[data-action="play-pause"]').attr('checked', 'checked')
    
    @
    
  next: =>
    @model.tool.trigger 'next-page'
    
  prev: =>
    @model.tool.trigger 'prev-page'
  
  onPlayPause: (e) =>
    isPlaying = $(e.target).is(':checked')
    @model.tool.settings({isPlaying: isPlaying})
  
  onReset: =>
    @model.tool.settings({imageIndex: 0})


module.exports = ImagePlayerSettings
