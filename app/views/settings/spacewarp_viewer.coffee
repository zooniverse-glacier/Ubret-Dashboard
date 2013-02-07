BaseView = require 'views/base_view'

class SpacewarpViewerSettings extends BaseView
  className: 'spacewarp-viewer-settings'
  template: require 'views/templates/settings/spacewarp_viewer'

  initialize: ->
    console.log 'initializing SpacewarpViewerSettings'

  render: =>
    @$el.html @template()
    @

module.exports = SpacewarpViewerSettings

