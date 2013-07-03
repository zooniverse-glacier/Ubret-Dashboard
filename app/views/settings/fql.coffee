BaseView = require 'views/base_view'

class Fql extends BaseView
  className: 'fql-settings'
  template: require 'views/templates/settings/fql'

  events:
    'click button.fql-submit' : 'parse'
    'keypress .fql-box' : 'parse'
    'click button.fql-cheatsheet-toggle' : 'toggleCheat'
    'click span.remove' : 'deleteStatement'

  initialize: ->
    @model.on 'add:fql_statements remove:fql_statements', @render

  parse: (e) =>
    return if e.type is 'keypress' and e.which isnt 13
    @model.get('fql_statements').add {string: @$('input.fql-box').val()}

  render: =>
    @$el.html @template
      commands: @model.get('fql_statements')?.toJSON()
    @

  toggleCheat: (e) => 
    e.preventDefault()
    @$('.fql-cheatsheet').toggleClass('active')

  deleteStatement: (e) =>
    string = e.target.dataset.string
    statements = @model.get('fql_statements')
    statement = _.first statements.filter((s) -> s.get('string') is string)
    statements.remove statement

module.exports = Fql