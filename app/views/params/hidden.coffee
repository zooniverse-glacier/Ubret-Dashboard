Param = require 'views/param'
Manager = require 'modules/manager'

class Hidden extends Param
  render: =>
    @

  setState: =>
    @model.set 'val', Manager.get(@model.get('data'))

module.exports = Hidden
