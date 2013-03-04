BaseView = require 'views/base_view'

class Param extends BaseView
  initialize: ->
    throw 'must pass a param' unless @model
    if @model.get('type') then @$el.addClass @model.get('type').toLowerCase()

  render: =>
    @$el.html @template(@model)
    @

  setState: =>
    @model.set 'val', @getCurrentValue()

  getCurrentValue: =>
    @$('[data-cid=' + @model.cid + ']').val()
    
module.exports = Param