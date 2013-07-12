BaseView = require 'views/base_view'


class ImagePlayerSettings extends BaseView
  className: 'image-player-settings'
  template: require 'views/templates/settings/image_player'

  events:
    'click button.next' : 'next'
    'click button.prev' : 'prev'

  initialize: ->
    @page = @model.get('settings').get('currentPage') or 0

  render: =>
    @$el.html @template()
    @

  next: =>
    @model.tool.trigger 'next-page'

  prev: =>
    @model.tool.trigger 'prev-page'


module.exports = ImagePlayerSettings
