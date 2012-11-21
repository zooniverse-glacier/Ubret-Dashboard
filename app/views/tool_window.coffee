UbretView = require 'views/ubret_view'
Settings = require 'views/settings'
ToolContainer = require 'views/tool_container'
WindowTitleBar = require 'views/window_title_bar'

class ToolWindow extends UbretView
  className: 'tool-window'
  template: require './templates/window'
  
  windowMinWidth: 300
  windowMinHeight: 150

  events:
    'click': 'focusWindow'
    'mousedown .resize': 'resizeWindowStart'
    'mouseup .resize': 'resizeWindowEnd'

  initialize: =>
    if @model?
      @model.on 'remove', @removeWindow

      @$el.css
        width: @model.get('width')
        height: @model.get('height')

      @generatePosition()
      @focusWindow() if @collection?
      @model.set 'zindex', @$el.css 'z-index'

    @settings = new Settings { model: @model }
    
    @toolContainer = new ToolContainer { model: @model }

    @titleBar = new WindowTitleBar { model: @model }
    @titleBar.on 'close', @close
    @titleBar.on 'settings', @toggleSettings
    @titleBar.on 'startDrag', @startDrag
    @titleBar.on 'endDrag', @endDrag
    @titleBar.on 'focusWindow', @focusWindow

  render: =>
    @$el.html @template()
    @assign
      '.title-bar': @titleBar
      '.settings': @settings
      '.tool-container': @toolContainer

    @


  # Events
  close: (e) =>
    @model.destroy()
    @removeWindow()

  focusWindow: (e) =>
    unless @$el.css('z-index') is @getMaxZIndex()
      @$el.css 'z-index', parseInt(@getMaxZIndex()) + 1
      @model.set 'zindex', @$el.css 'z-index'

  # Resize
  resizeWindowStart: (e) =>
    $('body').addClass 'unselectable'
    @resizing = true

    startX = e.pageX
    startY = e.pageY

    startWidth = @$el.width()
    startHeight = @$el.height()

    startLeft = @$el.offset().left
    startTop = @$el.offset().top

    doc_width = $(document).width()
    doc_height = $(document).height()

    $(document).on 'mousemove', (d_e) =>
      if @resizing

        if d_e.pageX > doc_width or d_e.pageY > doc_height
          return

        deltaX = d_e.pageX - startX
        deltaY = d_e.pageY - startY

        # Horizontal
        if $(e.currentTarget).hasClass('left')
          unless (startWidth - deltaX) < @windowMinWidth
            @$el.css
              left: startLeft + deltaX
              width: startWidth - deltaX

        if $(e.currentTarget).hasClass('right')
          unless (startWidth + deltaX) < @windowMinWidth
            @$el.css
              width: startWidth + deltaX

        # Vertical
        if $(e.currentTarget).hasClass('top')
          unless (startHeight - deltaY) < @windowMinHeight
            @$el.css
              top: startTop + deltaY
              height: startHeight - deltaY

        if $(e.currentTarget).hasClass('bottom')
          unless (startHeight + deltaY) < @windowMinHeight
            @$el.css
              height: startHeight + deltaY

  resizeWindowEnd: (e) =>
    $('body').removeClass 'unselectable'
    @resizing = false
    $(document).off 'mousemove'

    @model.set 
      left: @$el.css('left')
      top: @$el.css('top')
      width: @$el.css('width')
      height: @$el.css('height')

    @toolContainer.render().el

  # Drag
  startDrag: (e) =>
    $('body').addClass 'unselectable'
    @dragging = true

    startTop = @$el.offset().top
    startLeft = @$el.offset().left

    @relX = e.pageX - startLeft
    @relY = e.pageY - startTop

    $(document).on 'mousemove', (d_e) =>
      if @dragging
        top = -(startTop - (d_e.pageY - @relY))
        left = -(startLeft - (d_e.pageX - @relX))
        @$el.css
          transform: "translate(#{left}px, #{top}px)"

  endDrag: (e) =>
    $('body').removeClass 'unselectable'
    @dragging = false
    $(document).off 'mousemove'

    @model.set 
      left: e.pageX - @relX
      top: e.pageY - @relY

    @$el.css
      left: e.pageX - @relX
      top: e.pageY - @relY
      transform: ''


  # Helper functions
  removeWindow: =>
    @remove()

  toggleSettings: =>
    @$el.toggleClass 'settings-active'

  getMaxZIndex: =>
    @collection?.max((tool) -> parseInt(tool.get('zindex'))).get('zindex')

  generatePosition: ->
    doc_width = $(document).width()
    doc_height = $(document).height()

    x_max = doc_width * 0.6
    x_min = doc_width * 0.02

    y_max = doc_height * 0.35
    y_min = doc_height * 0.05

    x = Math.random() * (x_max - x_min) + x_min
    y = Math.random() * (y_max - y_min) + y_min

    @model.set
      top: y
      left: x

    @$el.css
      top: y
      left: x


module.exports = ToolWindow