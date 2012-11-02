Settings = require 'views/settings'
ToolContainer = require 'views/tool_container'
WindowTitleBar = require 'views/window_title_bar'

class ToolWindow extends Backbone.View
  _.extend @prototype, Backbone.Events

  tagName: 'div'
  className: 'tool-window'

  initialize: =>
    if @model?
      @model.on 'change', @setWindowPosition
      @model.on 'change', @setWindowSize
      @setWindowPosition()
      @setWindowSize()

    @settings = new Settings { model: @model }
    
    @toolContainer = new ToolContainer { model: @model }

    @titleBar = new WindowTitleBar { model: @model }
    @titleBar.on 'close', @close
    @titleBar.on 'settings', @toggleSettings

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

  close: =>
    @model.destroy()
    @remove()

module.exports = ToolWindow
