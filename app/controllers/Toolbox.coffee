Spine = require 'spine'

class Toolbox extends Spine.Controller
  
  events: 
    'click .tool' : 'selection'
    'click .remove-tools': 'clearDashboard'
  
  constructor: ->
    super

  render: =>
    @html require('views/toolbox')(@) if @el.html

  clearDashboard: (e) =>
    @trigger 'remove-all-tools'

  selection: (e) =>
    e.preventDefault()
    selected = $(e.currentTarget).attr('data-id')
    @trigger 'add-new-tool', selected
    
module.exports = Toolbox