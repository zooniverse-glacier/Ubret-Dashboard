AppView = require 'views/app_view'

class WindowTitleBar extends AppView
  tagName: 'div'
  className: 'title-bar'
  template: require './templates/window_title_bar'

  events:
    'click .window-close' : 'close'
    'click .open-settings' : 'settings'
    'dblclick .window-title' : 'editTitle'
    'keypress input[name="window-title"]' : 'updateModel'
    'blur input[name="window-title"]' : 'updateModel'
    'mousedown' : 'startDrag'
    'mouseup' : 'endDrag'

  initialize: ->
    unless @model then throw 'must pass a model'
    @model.on 'change:name', @render

  render: =>
    @$el.html @template({name: @model.get('name')})
    @

  close: =>
    @trigger 'close'

  settings: =>
    @trigger 'settings'

  startDrag: (e) =>
    @trigger 'focusWindow', e
    @trigger 'startDrag', e

  endDrag: (e) =>
    @trigger 'endDrag', e

  editTitle: =>
    @$('.window-title').hide()
    @$('input').show()

  updateModel: (e) =>
    if e.type is 'focusout' or e.which is 13
      input = @$('input')
      newTitle = input.val()
      if newTitle is @model.get('name')
        @$('.window-title').show()
        @$('input').hide()
      else
        @model.set 'name', newTitle


module.exports = WindowTitleBar