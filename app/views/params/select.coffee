Param = require 'views/param'

class Select extends Param
  template: require 'views/templates/params/select'

  getCurrentValue: =>
    @$el.find('[data-cid=' + @model.cid + ']').val()

module.exports = Select