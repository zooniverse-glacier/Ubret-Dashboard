class FQLStatements extends Backbone.Collection
  model: require 'models/fql_statement'

  filters: =>
    @chain().filter((s) -> s.isFilter()).map((s) -> s.get('func')).value()

  fields: =>
    @chain().filter((s) -> s.isField()).map((s) -> s.attributes).value()

module.exports = FQLStatements
