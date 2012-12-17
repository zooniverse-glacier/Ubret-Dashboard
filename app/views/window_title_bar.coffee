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
    'mouseup' : 'endDrag'

  initialize: ->
    unless @model then throw 'must pass a model'
    @viewOpts = new Object

    @model.on 'change:name', @render
    @model.on 'tool:dataProcessed', @updateToolLink

  render: =>
    @viewOpts['name'] = @model.get('name')
    @$el.html @template(@viewOpts)
    @

  minimize: =>
    @trigger 'minimize'

  close: =>
    @trigger 'close'

  startDrag: (e) =>
    @trigger 'focusWindow', e
    @trigger 'startDrag', e

  endDrag: (e) =>
    @trigger 'endDrag', e

  editTitle: =>
    @$('.window-title').hide()
    @$('input').show().focus().select()

  updateToolLink: =>
    unless @model.dataSource.isExternal()
      @viewOpts['link'] = @model.dataSource.get('source')
    else
      @viewOpts['link'] = null

    @render()

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