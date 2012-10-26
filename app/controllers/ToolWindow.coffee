Spine = require('spine')
_ = require 'underscore/underscore'
Settings = require('controllers/Settings')

class ToolWindow extends Spine.Controller
  className: "window-container"
  template: require 'views/window'

  events: 
    'click .window'            : 'focusWindow'
    'click .close-window'      : 'onCloseWindow'
    'click .toggle-settings'   : 'onToggleSettings'
    'click .minimize'          : 'onMinimizeWindow'
    'mousedown .window-title'  : 'startDrag'
    'mouseup'                  : 'endDrag'
    'mousedown .window'        : 'updateSize'
    'mouseup .window'          : 'resizeCheck'

  elements:
    '.window' : 'window'
    '.settings': 'settingsEl'

  isMinimized: false

  constructor: ->
    super
    @settings = new Settings { tool: @tool, toolSettings: @tool.settings or [] }

  render: =>
    title = @tool.channel
    @html @template({tool: @tool})

    @el.css 'z-index', @count

    @el.css @generatePosition()

    @tool.render()
    @settings.render()
    @prepend @settings.el
    @window.append @tool.el
    @focusWindow()

    @settingsEl.toggleClass 'active'

  updateSize: =>
    @width = @window.width()
    @height = @window.height()

  focusWindow: =>
    unless @el.css('z-index') is @getMaxZIndex() or @el.find('.tool').hasClass 'fullscreen'
      # or tool is set to fullscreen. intermediate hack above
      @el.css 'z-index', parseInt(@getMaxZIndex()) + 1

  # Title bar actions
  onCloseWindow: (e) =>
    e.stopPropagation()
    @trigger 'remove-tool', @tool
    @release()

  onToggleSettings: (e) =>
    e.stopPropagation()
    @settingsEl.toggleClass 'active'

  onMinimizeWindow: (e) =>
    e.stopPropagation()

    if @isMinimized
      @settingsEl.addClass 'active'
      @window.slideDown()
    else
      @settingsEl.removeClass 'active'
      @window.slideUp()

    @isMinimized = !@isMinimized

  resizeCheck: =>
    if @window.width() isnt @width or @window.height() isnt @height
      @tool.width = @window.width()
      @tool.height = @window.height()
      @tool.start()

  startDrag: (e) =>
    @focusWindow e
    @el.addClass 'unselectable'
    elWidth = @el.outerWidth()
    elHeight = @el.outerHeight()
    @dragging = true

    mouseOffset = @el.offset()
    relX = e.pageX - mouseOffset.left
    relY = e.pageY - mouseOffset.top

    $(document).on 'mousemove', (e) =>
      if @dragging
        @el.css
          top: e.pageY - relY
          left: e.pageX - relX

  endDrag: (e) =>
    $(document).unbind 'mousemove'
    @el.removeClass 'unselectable'
    @dragging = false

  onResize: (e) =>
    console.log e

  # Helper functions
  getMaxZIndex: =>
    z_indexes = []
    _.each $(".#{@className}"), (toolWindow) ->
      z_indexes.push $(toolWindow).css 'z-index'

    _.max z_indexes, (num) -> parseInt(num)

  generatePosition: ->
    doc_width = $(document).width()
    doc_height = $(document).height()

    x_max = doc_width * 0.6
    x_min = doc_width * 0.16

    y_max = doc_height * 0.7
    y_min = doc_height * 0.05

    x = Math.random() * (x_max - x_min) + x_min
    y = Math.random() * (y_max - y_min) + y_min

    return {
        top: y
        left: x
      }
    

module.exports = ToolWindow