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
    'mousedown' : 'startDrag'

  initialize: ->
    @editing = false
    @listenTo @model, 
      'update-name change:data_source.source_id change:name': @render
      'loading': @showLoading
      'loading-error': @showLoadingError
      'loaded': @showLoaded

  showLoading: =>
    @$('.loaded').hide()
    @$('.loading').show()
    @$('.loading-error').hide()

  showLoadingError: =>
    @$('.loading').hide()
    @$('.loaded').hide()
    @$('.loading-error').show()

  showLoaded: =>
    @$('.loading-error').hide()
    @$('.loading').hide()
    @$('.loaded').show()

  render: =>
    return @ unless @model.collection?
    @$el.html @template
      link: @model.sourceName()
      name: @model.get('name')
      editing: @editing
    @$('input').focus().select() if @editing
    @

  minimize: =>
    @trigger 'minimize'

  close: =>
    @trigger 'close'

  startDrag: (e) =>
    @trigger 'startDrag', e

  endDrag: (e) =>
    @trigger 'endDrag', e

  editTitle: (e) =>
    console.log e
    e.preventDefault() 
    @editing = true
    @$('.window-title').addClass('editing')
    @$('input').addClass('editing').focus().select()

  updateModel: (e) =>
    if e.type is 'focusout' or e.which is 13
      @editing = false
      input = @$('input')
      newTitle = input.val()
      if newTitle is @model.get('name')
        @$('.window-title').show()
        @$('input').hide()
      else
        @model.updateFunc 'name', newTitle


module.exports = WindowTitleBar