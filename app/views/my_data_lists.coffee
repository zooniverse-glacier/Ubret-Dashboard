BaseView = require 'views/base_view'

class MyDataLists extends BaseView
  initialize: ->
    @collection = new @collectionClass
    @collection.on 'add reset', @render

  loadCollection: =>
    @collection.fetch()

  render: =>
    @$el.html @template()
    if not @collection.isEmpty()
      @collection.each (model) =>
        @$('.recents').append @templateItem(model.toJSON())
    @



module.exports = MyDataLists
