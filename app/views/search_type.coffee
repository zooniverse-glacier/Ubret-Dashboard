BaseView = require 'views/base_view'

class SearchType extends BaseView
  template: require './templates/search_type'

  initialize: ->
    @types = []

  set: (types) =>
    if _.isArray(types)
      @types = types
    else
      @types.push types

    @model.set 'search_type', @types[0].name

  render: =>
    for type in @types
      console.log @model.get('search_type') is type.name
    @$el.html @template({types: @types, selectedType: @model.get('search_type')})
    @

module.exports = SearchType