BaseView = require 'views/base_view'

Settings = require 'views/settings'
UbretView = require 'views/ubret'
WindowTitleBar = require 'views/window_title_bar'

Snapping = require 'views/snapping'

class ToolWindow extends BaseView
  _.extend @prototype, Snapping

  className: 'tool-window'
  template: require './templates/window'

  windowMinWidth: 300
  windowMinHeight: 150

  events:
    'mousedown .resize': 'resizeWindowStart'

  initialize: ->
    if @model?
      @model.on 'destroy', @removeWindow
      @model.on 'change:zindex', @setZindex
      @model.on 'change:left change:top', @setPosition
      @model.on 'change:width change:height', @setSize

      @$el.css @initialSizeAndPosition()

    @settings = new Settings {model: @model}
    @ubretView = new UbretView {model: @model, el: @$('.tool-container')}
    @titleBar = new WindowTitleBar {model: @model}

    @titleBar.on 'minimize', @minimize
    @titleBar.on 'close', @close
    @titleBar.on 'startDrag', @startDrag
    
    @dashWidth = window.innerWidth
    @dashTop = 170
    @dashBottom = window.innerHeight - 50
    @dashHeight = @dashBottom - @dashTop

    $(window).on 'resize', =>
      @dashWidth = window.innerWidth
      @dashBottom = window.innerHeight - 50
      @dashHeight = @dashBottom - @dashTop

  initialSizeAndPosition: =>
    sizeAndPos = new Object
    sizeAndPos[key] = @model.get(key) for key in ['left', 'top', 'width', 'height', 'zindex']
    sizeAndPos['z-index'] = sizeAndPos.zindex
    sizeAndPos

  render: =>
    active = if @model.get('active') then 'active' else ''
    @$el.html @template({active: active})
    @$el.attr('data-channel', @model.get('channel'))
    @assign
      '.title-bar': @titleBar
      '.settings': @settings
    @


  # Events
  postDashboardAppend: =>
    @assign '.tool-container', @ubretView

  removeWindow: =>
    @remove()

  minimize: (e) =>
    @$el.toggleClass 'minimized'

  close: (e) =>
    @model.destroy()
    @removeWindow()

  setZindex: =>
    @$el.css 'z-index', @model.get('zindex')

  setPosition: =>
    @$el.css
      top: @model.get('top')
      left: @model.get('left')

  setSize: =>
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

    @model.save
      left: @$el.css('left')
      top: @$el.css('top')
      width: @$el.css('width')
      height: @$el.css('height')

    @ubretView.render()


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
        @showSnap d_e.pageX, d_e.pageY
        top = -(startTop - (d_e.pageY - @relY))
        left = -(startLeft - (d_e.pageX - @relX))
        @$el.css
          transform: "translate(#{left}px, #{top}px)"

    $(document).on 'mouseup', @endDrag

  endDrag: (e) =>
    $('body').removeClass 'unselectable'
    @dragging = false
    $(document).off 'mousemove'
    $(document).off 'mouseup'

    if @snap 
      @setSnap e.pageX, e.pageY
      @ubretView.render()
    else
      @model.save
        left: e.pageX - @relX
        top: e.pageY - @relY

    Backbone.Mediator.publish 'stop-snap'
    @$el.css
      transform: ''


module.exports = ToolWindow