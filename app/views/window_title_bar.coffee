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
    @loading = false
    @loadingError = false
    @listenTo @model, 
      'change:data_source change:name': @render
      'loading': @showLoading
      'loading-error': @showLoadingError

  showLoading: =>
    @$('.loading').show()

  showLoadingError: =>
    @$('.loading-error').show()

  render: =>
    return @ unless @model.collection?
    @$el.html @template
      link: @model.sourceName()
      name: @model.get('name')
    @

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
        @model.updateFunc 'name', newTitle


module.exports = WindowTitleBar