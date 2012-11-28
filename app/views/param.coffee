AppView = require 'views/app_view'

class Param extends AppView

  initialize: ->
    throw 'must pass a param' unless @model

  render: =>
    @$el.html @template(@model)
    @

  setState: =>
    # getCurrentValue implemented by subclasses
    @model.set('value', @getCurrentValue())

module.exports = Param