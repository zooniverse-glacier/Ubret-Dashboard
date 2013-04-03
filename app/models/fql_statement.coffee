class Filter extends Backbone.AssociatedModel
  initialize: ->
    @parseFql()

  toJSON: =>
    {string: @get('string')}

  parseFql: =>
    string = @get('string')
    @set Fql.Parser.parse(string)[0].eval()

  isFilter: =>
    !@isField()

  isField: =>
    @get('field')?

module.exports = Filter
