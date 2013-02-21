BaseView = require 'views/base_view'

class WindowTitleBar extends BaseView
  tagName: 'div'
  className: 'title-bar'
  template: require './templates/window_title_bar'

  events:
    'click .window-min': 'minimize'
    'click .window-close' : 'close'
    'dblclick .window-title' : 'editTitle'
    'keypress input[name="window-title"]' : 'updateModel'
    'blur input[name="window-title"]' : 'updateModel'
    'mousedown' : 'startDrag'

  initialize: ->
    unless @model then throw 'must pass a model'

    @model.on
      'render': @render 
      'change:name': @render

    if @model.get('data_source').isInternal()
      @model.sourceTool().on 'change:name', @render

  render: =>
    opts =
      'link': @model.sourceName()
      'name': @model.get('name')
    @$el.html @template(opts)

  minimize: =>
    @trigger 'minimize'

  close: =>
    @trigger 'close'

  startDrag: (e) =>
    @trigger 'startDrag', e

  endDrag: (e) =>
    @trigger 'endDrag', e

  editTitle: =>
    @$('.window-title').hide()
    @$('input').show().focus().select()

  updateModel: (e) =>
    if e.type is 'focusout' or e.which is 13
      input = @$('input')
      newTitle = input.val()
      if newTitle is @model.get('name')
        @$('.window-title').show()
        @$('input').hide()
      else
        @model.save 'name', newTitle


module.exports = WindowTitleBar