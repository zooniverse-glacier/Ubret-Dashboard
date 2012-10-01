Spine = require('spine')
Settings = require('controllers/Settings')

class ToolWindow extends Spine.Controller
  className: "window"

  events: 
    'click .close-window'    : 'closeWindow'
    'mousedown .window-controls' : 'startDrag'
    'mouseup'   : 'endDrag'
    'click .toggle-settings' : 'toggleSettings'

  constructor: ->
    super
    @settings = new Settings { tool: @tool, toolSettings: @tool.settings or [] }

  render: =>
    @el.css 'z-index', @count
    @tool.render()
    @settings.render()
    @append @windowControls()
    @append @tool.el
    @append @settings.el

  windowControls: ->
    """
    <div class="window-controls">
      <ul>
        <li><a class="close-window">X</a></li>
        <li><a class="move-window">#{@tool.channel}</a></li>
        <li><a class="toggle-settings">settings</a></li>
      </ul>
    </div>
    """

  toggleSettings: (e) =>
    @$el.toggleClass 'settings-active'

  closeWindow: (e) =>
    @trigger 'remove-tool', @tool
    @release()

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

module.exports = ToolWindow