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
    @tool.render()
    @settings.render()
    @window.append @settings.el
    @window.append @tool.el

  updateSize: (e) =>
    @width = @window.width()
    @height = @window.height()

  toggleSettings: (e) =>
    toolWidth = @tool.el.width()
    @window.toggleClass 'settings-active'

  closeWindow: (e) =>
    @trigger 'remove-tool', @tool
    @release()

  resizeCheck: (e) =>
    if @window.width() isnt @width or @window.height() isnt @height
      @tool.width = @window.width()
      @tool.height = @window.height()
      @tool.start()

  startDrag: (e) =>
    $('body').addClass 'unselectable'
    elWidth = @$el.outerWidth()
    elHeight = @$el.outerHeight()
    @dragging = true

    mouseOffset = @$el.offset()
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

module.exports = ToolWindow