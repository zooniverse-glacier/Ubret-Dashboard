BaseView = require 'views/base_view'
User = require 'user'

class SavedList extends BaseView
  itemTemplate: require './templates/saved_dashboards/item'
  listTemplate: require './templates/saved_dashboards/list'

  events:
    'click a.delete' : 'deleteDashboard'
    'click a.share'  : 'shareDashboard'

  initialize: ->
    @collection.on 'remove', @render

  render: =>
    @$el.html @listTemplate()

    @collection?.each (dashboard) =>
      item =
        id: dashboard.id
        name: dashboard.get('name')
        lastModified: dashboard.get('last_modified')

      @$el.find('.dashboards').append @itemTemplate(item)
    @

  shareDashboard: (e) =>
    e.preventDefault()

  deleteDashboard: (e) =>
    e.preventDefault()
    id = e.currentTarget.dataset.id
    @collection.remove id
    User.current.removeDashboards id

module.exports = SavedList