AppView = require 'views/app_view'

class Param extends AppView

  initialize: ->
    throw 'must pass a param' unless @model

  render: =>
    switch @model.get('type')
      when 'String' then template = require './templates/params/input'
      else template = require './templates/params/empty'

    @$el.html template(@model)
    @

  setState: =>
    switch @model.get('type')
      when 'String' then @model.set('value', @$el.find('[data-cid=' + @model.cid + ']').val())
      else @model.set('value', '')

module.exports = Param