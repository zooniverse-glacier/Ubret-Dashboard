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
    @$el.html @template({types: @types, selectedType: @model.get('search_type')})
    @

  # Events
  onSelectType: (e) =>
    @model.set 'search_type', e.currentTarget.value
    @trigger 'change'

module.exports = SearchType