Spine = require 'spine'
_ = require 'underscore/underscore'

class State extends Spine.Controller

  constructor: ->
    super
    @saveState()

  saveState: =>
    state = new Object()
    console.log 'DB:', @dashboard

    tools = []
    for tool in @dashboard.tools
      pos = tool.el.offset()
      z_index = if _.isNaN(parseInt(tool.el.css('z-index'))) then 0 else tool.el.css('z-index')
      obj = {

          'channel': tool.channel,
          'filters': tool.filters,
          'pos': pos,
          'z-index': parseInt(z_index)
        }

      tools.push obj

    state = {
        'tools': tools
      }
    console.log 'State: ', state


module.exports = State