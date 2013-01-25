BaseView = require 'views/base_view'
User = require 'user'

Sharing = require 'views/sharing'

class SavedList extends BaseView
  itemTemplate: require './templates/saved_dashboards/item'
  listTemplate: require './templates/saved_dashboards/list'

  events:
    'click a.delete': 'deleteDashboard'
    'click a.share': 'shareDashboard'

  initialize: ->
    @collection?.on 'remove', @render
    @sharers = new Object

  render: =>
    @$el.html @listTemplate()
    @collection?.each (dashboard) =>
      item =
        id: dashboard.id
        name: dashboard.get('name')
        lastModified: new Date(dashboard.get('updated_at')).toLocaleString()
      if typeof @sharers[dashboard.id] is 'undefined'
        @sharers[dashboard.id] = new Sharing {model: dashboard}
      @$el.find('.dashboards').append @itemTemplate(item)
    @

  shareDashboard: (e) =>
    e.preventDefault()
    id = e.currentTarget.dataset.id
    @$('.sharer').remove()
    if id is @openId
      @openId = null
    else
      @$(e.currentTarget).parent().append @sharers[id].render().el
      @openId = id

  deleteDashboard: (e) =>
    e.preventDefault()
    id = e.currentTarget.dataset.id
    @collection.remove id
    delete @sharers[id]
    User.current.removeDashboard id, ->
      $(e.currentTarget).parents().eq(3).remove()

module.exports = SavedList