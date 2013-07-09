BaseView = require 'views/base_view'

class Dialog extends BaseView
  className: 'dialog'
  tag: 'div'

  dialogTemplate: require './templates/dialog'

  initialize: (options) ->
    @parent = options.parent
 
  close: =>
    @remove()

  confirm: (e) =>
    unless e.type is 'keypress' and e.which isnt 13
      e.preventDefault()
      @confirmCallback(e)
      @close()

  events: 
    'click span.window-close' : 'close'
    'click button.close' : 'close'
    'click button.confirm' : 'confirm'
    'keypress' : 'confirm'

  render: =>
    @$el.html @dialogTemplate
      title: @title
      confirmation: @confirmation
    @

  content: (content) =>
    @$('.dialog-content').html content

module.exports = Dialog
