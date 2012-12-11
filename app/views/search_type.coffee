BaseView = require 'views/base_view'

class SearchType extends BaseView
  template: require './templates/search_type'

  events:
    'change select': 'onSelectType'

  initialize: ->
    @types = []

  set: (types) =>
    if _.isArray(types)
      @types = types
    else
      @types.push types

  render: =>
    @$el.html @template({types: @types, selectedType: @selectedType})
    @

  # Events
  onSelectType: (e) =>
    @selectedType = $(e.currentTarget).val()
    @trigger 'searchType:typeSelected', @selectedType

module.exports = SearchType