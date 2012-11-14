Settings = require 'views/settings'
ToolContainer = require 'views/tool_container'
WindowTitleBar = require 'views/window_title_bar'

class ToolWindow extends Backbone.View
  _.extend @prototype, Backbone.Events

  tagName: 'div'
  className: 'tool-window'

  events:
    'click': 'focusWindow'

  initialize: =>
    if @model?
      @model.on 'change:top change:left', @setWindowPosition
      @model.on 'change:width change:height', @setWindowSize
      @model.on 'remove', @removeWindow
      @setWindowSize()

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

  focusWindow: (e) =>
    unless @$el.css('z-index') is @getMaxZIndex()
      @$el.css 'z-index', parseInt(@getMaxZIndex()) + 1
      @model.set 'zindex', @$el.css 'z-index'

  removeWindow: =>
    @remove()

  setWindowPosition: =>
    @$el.css 'left', @model.get('left')
    @$el.css 'top', @model.get('top')

  setWindowSize: =>
    @$el.css 'height', @model.get('height')
    @$el.css 'width', @model.get('width') 

  render: =>
    @toggleSettings()
    _.each([ @titleBar, @settings, @toolContainer ], (section) =>
      @$el.append section.render().el)
    @

  toggleSettings: =>
    @$el.toggleClass 'settings-active'

  close: (e) =>
    @model.destroy()
    @remove()

  startDrag: (e) =>
    $('body').addClass 'unselectable'
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

    $('body').removeClass 'unselectable'
    @$el.css
      transform: ''

  # Helper functions
  getMaxZIndex: =>
    (@collection?.max((tool) -> parseInt(tool.attributes.zindex))).attributes.zindex

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


module.exports = ToolWindow