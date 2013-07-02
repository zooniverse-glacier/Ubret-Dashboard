Dialog = require 'views/dialog'

class NonOwnerDialog extends Dialog
  template: "<p>You are not the owner of this Dashboard. To modify it, you must first make a copy of the Dashboard.</p>"

  initialize: ->
    options = {}
    super options

  render: =>
    super
    @content @template
    @

  confirmation: 'Copy Dashboard'
  title: 'Not Allowed to Modify'
  confirmCallback: (e) =>
    Backbone.Mediator.publish 'dashboard:fork'

module.exports = NonOwnerDialog
