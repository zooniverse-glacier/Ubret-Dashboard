Param = require 'views/param'

class Range extends Param
  template: require 'views/templates/params/range'

  events:
    'change': 'render'

  initialize: ->
    super
    @min = @model.get('validation')[0]
    @max = @model.get('validation')[1]

  render: =>
    super
    @$('.value').html @getCurrentValue().toFixed(2)
    @

  getCurrentValue: =>
    parseFloat(@$('input[type="range"]').val())

module.exports = Range