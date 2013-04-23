BaseView = require 'views/base_view'

class Fql extends BaseView
  className: 'fql-settings'
  template: require 'views/templates/settings/fql'

  events:
    'click button.fql-submit' : 'parse'
    'keypress .fql-box' : 'parse'
    'click button.fql-cheatsheet-toggle' : 'toggleCheat'

  parse: (e) =>
    return if e.type is 'keypress' and e.which isnt 13
    @model.get('fql_statements').add {string: @$('input.fql-box').val()}
    @$('input.fql-box').val('')

  render: =>
    @$el.html @template(@model.get('filters')?.toJSON())
    @

  toggleCheat: (e) => 
    e.preventDefault()
    @$('.fql-cheatsheet').toggleClass('active')

module.exports = Fql