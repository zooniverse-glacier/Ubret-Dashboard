class WindowTitleBar extends Backbone.View
  _.extend @prototype, Backbone.Events

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
    @model?.on 'change:name', @render

  render: =>
    title = @model?.get('name')
    @$el.html @template({name: title})
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
