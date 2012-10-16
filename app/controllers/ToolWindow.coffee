Spine = require('spine')
Settings = require('controllers/Settings')

class ToolWindow extends Spine.Controller
  className: "window-container"

  events: 
    'click .close-window'        : 'closeWindow'
    'mousedown .window-controls' : 'startDrag'
    'mouseup'                    : 'endDrag'
    'click .toggle-settings'     : 'toggleSettings'
    'mousedown .window'          : 'updateSize'
    'mouseup .window'            : 'resizeCheck'

  elements:
    '.window' : 'window'

  constructor: ->
    super
    @settings = new Settings { tool: @tool, toolSettings: @tool.settings or [] }

  template: require 'views/window'

  render: =>
    title = @tool.channel
    @html @template({title})

    @el.css 'z-index', @count

    @el.offset @generatePosition()

    @tool.render()
    @settings.render()
    @window.append @settings.el
    @window.append @tool.el

  updateSize: (e) =>
    @width = @window.width()
    @height = @window.height()

  toggleSettings: (e) =>
    e.stopPropagation()
    toolWidth = @tool.el.width()
    @window.toggleClass 'settings-active'

  closeWindow: (e) =>
    e.stopPropagation()
    @trigger 'remove-tool', @tool
    @release()

  resizeCheck: (e) =>
    if @window.width() isnt @width or @window.height() isnt @height
      @tool.width = @window.width()
      @tool.height = @window.height()
      @tool.start()

  startDrag: (e) =>
    $('body').addClass 'unselectable'
    elWidth = @el.outerWidth()
    elHeight = @el.outerHeight()
    @dragging = true

    mouseOffset = @el.offset()
    relX = e.pageX - mouseOffset.left
    relY = e.pageY - mouseOffset.top

    $(document).on 'mousemove', (e) =>
      if @dragging
        @$el.offset
          top: e.pageY - relY
          left: e.pageX - relX

  endDrag: (e) =>
    $('body').removeClass 'unselectable'
    @dragging = false

  onResize: (e) =>
    console.log e

  # Helper functions
  generatePosition: ->
    doc_width = $(document).width()
    doc_height = $(document).height()

    x_max = doc_width * 0.5
    x_min = doc_width * 0.05

    y_max = doc_height * 0.5
    y_min = doc_height * 0.05

    x = Math.random() * (x_max - x_min) + x_min
    y = Math.random() * (y_max - y_min) + y_min

    return {
        top: y
        left: x
      }
    

module.exports = ToolWindow