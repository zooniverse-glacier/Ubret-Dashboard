Spine = require('spine')
_ = require 'underscore/underscore'
Settings = require('controllers/Settings')

class ToolWindow extends Spine.Controller
  className: "window-container"
  template: require 'views/window'

  events: 
    'click .window'            : 'focusWindow'
    'click .close-window'      : 'closeWindow'
    'click .toggle-settings'   : 'toggleSettings'
    'mousedown .window-title'  : 'startDrag'
    'mouseup'                  : 'endDrag'
    'mousedown .window'        : 'updateSize'
    'mouseup .window'          : 'resizeCheck'

  elements:
    '.window' : 'window'
    '.settings': 'settingsEl'

  constructor: ->
    super
    @settings = new Settings { tool: @tool, toolSettings: @tool.settings or [] }

  render: =>
    title = @tool.channel
    @html @template({title})

    @el.css 'z-index', @count

    @el.offset @generatePosition()

    @tool.render()
    @settings.render()
    @prepend @settings.el
    @window.append @tool.el
    @focusWindow()

    @settingsEl.toggleClass 'active'

  updateSize: =>
    @width = @window.width()
    @height = @window.height()

  toggleSettings: (e) =>
    e.stopPropagation()
    @settingsEl.toggleClass 'active'

  focusWindow: =>
    unless @el.css('z-index') is @getMaxZIndex()
      @el.css 'z-index', parseInt(@getMaxZIndex()) + 1

  closeWindow: (e) =>
    e.stopPropagation()
    @trigger 'remove-tool', @tool
    @release()

  resizeCheck: =>
    if @window.width() isnt @width or @window.height() isnt @height
      @tool.width = @window.width()
      @tool.height = @window.height()
      @tool.start()

  startDrag: (e) =>
    @focusWindow e
    $('body').addClass 'unselectable'
    elWidth = @el.outerWidth()
    elHeight = @el.outerHeight()
    @dragging = true

    mouseOffset = @el.offset()
    relX = e.pageX - mouseOffset.left
    relY = e.pageY - mouseOffset.top

    $(document).on 'mousemove', (e) =>
      if @dragging
        @el.offset
          top: e.pageY - relY
          left: e.pageX - relX

  endDrag: (e) =>
    $('body').removeClass 'unselectable'
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

    y_max = doc_height * 0.5
    y_min = doc_height * 0.05

    x = Math.random() * (x_max - x_min) + x_min
    y = Math.random() * (y_max - y_min) + y_min

    return {
        top: y
        left: x
      }
    

module.exports = ToolWindow