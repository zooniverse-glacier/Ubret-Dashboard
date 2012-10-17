Spine = require 'spine'
_ = require 'underscore/underscore'

Statistics = require('ubret/lib/controllers/Statistics')

class State extends Spine.Controller

  constructor: ->
    super

  save: (params) =>
    state = new Object()
    dashboard = params.dashboard
    console.log 'DB:', dashboard

    tools = []
    for tool in dashboard.tools
      pos = tool.el.offset()
      z_index = if _.isNaN(parseInt(tool.el.css('z-index'))) then 0 else tool.el.css('z-index')
      obj = {
          'channel': tool.channel,
          'filters': tool.filters,
          'binding': tool.bindOptions
          'pos': pos,
          'z-index': parseInt(z_index)
        }

      tools.push obj

    state = {
        'tools': tools
      }
    console.log 'State: ', JSON.stringify(state)

    $.post 'http://localhost:3001/state', {state: JSON.stringify(state)}, (data) ->
      console.log 'state saved', data

  load: (params) =>
    console.log 'loading state...'

    # Reset dashboard
    @trigger 'remove-all-tools'
    $.get "http://localhost:3001/state/#{params.state_id}", (data) ->
      data = JSON.parse data.state
      console.log 'state: ', data

      for tool in data.tools
        params.dashboard.createTool Statistics

    

module.exports = State