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

  startDrag: =>
    @trigger 'startDrag'

  endDrag: =>
    @trigger 'endDrag'

  editTitle: =>
    @$('.window-title').hide()
    @$('input[name="window-title"]').show()

  updateModel: (e) =>
    if e.which is 27
      @$('.window-title').show()
      @$('input[name="window-title"]').hide()
      return
    else if e.type is 'blur' or e.which is 13
      input = @$('input[name="window-title"]')
      newTitle = input.val()
      @model.set 'title', newTitle


module.exports = WindowTitleBar 
