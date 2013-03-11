Param = require 'views/param'

class Checkbox extends Param
  template: require 'views/templates/params/checkbox'

  getCurrentValue: =>
    if @$('[data-cid=' + @model.cid + ']').is(':checked')
      'spec'
    else
      ''

module.exports = Checkbox
