Settings = require 'views/settings'
ToolContainer = require 'views/tool_container'
WindowTitleBar = require 'views/window_title_bar'

class ToolWindow extends Backbone.View
  _.extend @prototype, Backbone.Events

  tagName: 'div'
  className: 'tool-window'

  events:
    'click': 'setWindowFocus'

  initialize: =>
    if @model?
      @model.on 'change:top change:left', @setWindowPosition
      @model.on 'change:width change:height', @setWindowSize
      @setWindowPosition()
      @setWindowSize()
      @setWindowFocus(@options.count)

    @settings = new Settings { model: @model }
    
    @toolContainer = new ToolContainer { model: @model }

    @titleBar = new WindowTitleBar { model: @model }
    @titleBar.on 'close', @close
    @titleBar.on 'settings', @toggleSettings
    @titleBar.on 'startDrag', @startDrag
    @titleBar.on 'endDrag', @endDrag

  setWindowFocus: (index = null) =>
    if index?
      @$el.css 'z-index', index
      return

    unless @$el.css('z-index') is @getMaxZIndex()
      @$el.css 'z-index', parseInt(@getMaxZIndex()) + 1

  setWindowPosition: =>
    @$el.css 'left', @model.get('left')
    @$el.css 'top', @model.get('top')

  setWindowSize: =>
    @$el.css 'height', @model.get('height')
    @$el.css 'width', @model.get('width')

  render: =>
    _.each([ @titleBar, @settings, @toolContainer ], (section) =>
      @$el.append section.render().el)
    @

  toggleSettings: =>
    @$el.toggleClass 'settings-active'

  close: (e) =>
    @model.destroy()
    @remove()

  focusWindow: (e) =>


  startDrag: (e) =>
    @$el.addClass 'unselectable'
    @dragging = true

    mouseOffset = @$el.offset()
    @relX = e.pageX - mouseOffset.left
    @relY = e.pageY - mouseOffset.top

    $(document).on 'mousemove', (e) =>
      if @dragging
        topMove = -(@model.get('top') - (e.pageY - @relY))
        leftMove = -(@model.get('left') - (e.pageX - @relX))
        @$el.css
          transform: "translate(#{leftMove}px, #{topMove}px)"

  endDrag: (e) =>
    @dragging = false
    $(document).off 'mousemove'
    mouseOffset = @$el.offset()

    @model.set 
      left: e.pageX - @relX
      top: e.pageY - @relY

    @$el.removeClass 'unselectable'
    @$el.css
      transform: ''

  # Helper functions
  getMaxZIndex: =>
    z_indexes = []
    _.each $(".#{@className}"), (toolWindow) ->
      z_indexes.push $(toolWindow).css 'z-index'

    _.max z_indexes, (num) -> parseInt(num)


module.exports = ToolWindow