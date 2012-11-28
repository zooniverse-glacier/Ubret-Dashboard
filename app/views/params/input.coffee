Param = require 'views/param'

class Input extends Param
  template: require 'views/templates/params/input'

  getCurrentValue: =>
    @$el.find('[data-cid=' + @model.cid + ']').val()

module.exports = Input