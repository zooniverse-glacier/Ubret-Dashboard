class Collections extends Backbone.View
  user: require 'lib/user'
  template: require './templates/collections'
  itemTemplate: require './templates/collection'
  manager: require 'modules/manager'

  initialize: ->
    @collection = @user.current.collections
    @collection.on 'add reset', @render

  loadCollection: =>
    @collection.fetch() if @manager.get('project')

  reset: =>
    @collection.reset()

  render: =>
    @$el.html @template()
    for model in @collection.formatModels()
      @$('.my-data-list').append @itemTemplate(model.toJSON()) 
    @

module.exports = Collections
