BaseView = require 'views/base_view'

class Fql extends BaseView
  className: 'fql-settings'
  template: require 'views/templates/settings/fql'

  events:
    'click button.fql-submit' : 'parse'

  parse: (e) =>
    console.log @$('textarea.fql-box').val()
    fql = Ubret.Fql.Parser.parse(@$('textarea.fql-box').val())
    for statement in fql
      @model.tool.filters statement.eval().func

  render: =>
    @$el.html @template(@model.toJSON())
    @

module.exports = Fql