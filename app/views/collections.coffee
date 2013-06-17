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

  dashboardUrl: (ids, title) =>
    "#/project/#{@manager.get('project')}/#{ids.join(',')}/Dashboard-from-#{title}"

  render: =>
    @$el.html @template()
    for model in @collection.formatModels()
      ids = _.map model.get('subjects'), (s) -> s.zooniverse_id
      @$('.my-data-list').append @itemTemplate
        image: model.get('images')[0]
        title: model.get('title')
        url: @dashboardUrl(ids, model.get('title'))
    @

module.exports = Collections
