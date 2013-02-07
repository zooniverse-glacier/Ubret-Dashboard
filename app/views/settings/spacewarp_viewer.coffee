BaseView = require 'views/base_view'

class SpacewarpViewerSettings extends BaseView
  className: 'spacewarp-viewer-settings'
  template: require 'views/templates/settings/spacewarp_viewer_settings'

  # events:
  #   'click button.next' : 'nextPage'
  #   'click button.prev' : 'prevPage'

  initialize: ->
    console.log 'initializing SpacewarpViewerSettings'

  render: =>
    @$el.html @template()
    @

module.exports = SpacewarpViewerSettings

