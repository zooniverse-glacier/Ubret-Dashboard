Spine = require 'spine'

class Toolbox extends Spine.Controller
  
  events: 
    'click .tool' : 'createTool'
    'click .save-state': 'saveDashboard'
    'click .remove-tools': 'clearDashboard'
  
  constructor: ->
    super

  render: =>
    @html require('views/toolbox')(@) if @el.html

  saveDashboard: ->
    Spine.trigger 'save-state'

  clearDashboard: (e) =>
    @trigger 'remove-all-tools'

  createTool: (e) =>
    e.preventDefault()
    selected = $(e.currentTarget).attr('data-id')
    @trigger 'add-new-tool', selected
    
module.exports = Toolbox