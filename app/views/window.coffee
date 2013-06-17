BaseView = require 'views/base_view'

class Window extends BaseView
  className: 'tool-window'

  windowTemplate: require './templates/window'
  windowTitleBarView: require 'views/window_title_bar'
  settingsView: require 'views/settings'

  windowMinWidth: 300
  windowMinHeight: 150

  initialize: ->
    @settings = new @settingsView {model: @model}
    @titleBar = new @windowTitleBarView {model: @model}
    @$el.css @initialSizeAndPosition()

    @$el.on 'mousedown', '.resize', @resizeWindowStart
    @$el.on 'click', @focus

    @listenTo @titleBar,
      'close': @close
      'minimize': @minimize
      'startDrag': @startDrag

    @listenTo @model, 
      'change:_id' : @updateWindowId
      'destroy': @removeWindow
      'change:zindex': @setZindex
      'change:left change:top': @setPosition
      'change:width change:height': @setSize

  focus: =>
    @model.collection?.focus(@model)

  initialSizeAndPosition: =>
    sizeAndPos = new Object
    for key in ['left', 'top', 'width', 'height', 'zindex']
      sizeAndPos[key] = @model.get(key)
    sizeAndPos['z-index'] = sizeAndPos.zindex
    sizeAndPos

  updateWindowId: =>
    @$el.attr 'data-id', @model.id

  render: =>
    @$el.html @windowTemplate
      locked: (@locked or false)
    @$el.attr 'data-id', @model.id
    @assign
      '.title-bar': @titleBar
      '.settings': @settings
    @

  removeWindow: =>
    @settings.remove()
    @titleBar.remove()
    @remove()

  minimize: (e) =>
    @$el.toggleClass 'minimized'

  close: (e) =>
    @model.destroy()

  setZindex: =>
    @$el.css 'z-index', @model.get('zindex')

  setPosition: =>
    @$el.css
      top: @model.get('top')
      left: @model.get('left')

  setSize: =>
    @$('.tool-container').height(parseInt(@model.get('height')) - 25)
    @$el.css
      width: @model.get('width')
      height: @model.get('height')

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

    $(document).on 'mouseup', @resizeWindowEnd
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

  resizeWindowEnd: =>
    $('body').removeClass 'unselectable'
    @resizing = false
    $(document).off 'mousemove mouseup'

    @model.updateFunc
      left: @$el.css('left')
      top: @$el.css('top')
      width: @$el.css('width')
      height: @$el.css('height')

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

    $(document).on 'mouseup', @endDrag

  endDrag: (e) =>
    $('body').removeClass 'unselectable'
    @dragging = false
    $(document).off 'mousemove mouseup'

    @model.updateFunc
      left: e.pageX - @relX
      top: e.pageY - @relY

    @$el.css
      transform: ''

module.exports = Window
