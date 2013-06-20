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

  dashboardUrl: (id, title) =>
    "#/project/#{@manager.get('project')}/collection/#{id}/Dashboard-from-#{title}"

  render: =>
    @$el.html @template()
    for model in @collection.formatModels()
      @$('.my-data-list').append @itemTemplate
        image: model.get('images')[0]
        title: model.get('title')
        url: @dashboardUrl(model.get('zooniverse_id'), model.get('title'))
    @

module.exports = Collections
