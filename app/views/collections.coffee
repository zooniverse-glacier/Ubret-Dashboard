class Collections extends Backbone.View
  talkCollection: require 'collections/talk_collections'
  template: require './templates/collections'
  itemTemplate: require './templates/collection'
  manager: require 'modules/manager'

  initialize: ->
    @collection = new @talkCollection
    @collection.on 'add reset', @render

  loadCollection: =>
    @collection.fetch() if @manager.get('project')

  resetCollection: =>
    @collection.reset()

  render: =>
    @$el.html @template()
    for model in @collection.formatModels()
      @$('.collections').append @itemTemplate(model.toJSON()) 
    @

module.exports = Collections
