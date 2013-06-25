Param = require 'views/param'

class Range extends Param
  template: require 'views/templates/params/range'

  events:
    'mousemove' : 'setVal'

  initialize: ->
    super
    @min = @model.get('validation')[0]
    @max = @model.get('validation')[1]

  setVal: =>
    @$('.value').html @getCurrentValue().toFixed(2)

  render: =>
    super
    @setVal()
    @

  getCurrentValue: =>
    parseFloat(@$('input[type="range"]').val())

module.exports = Range