BaseView = require 'views/base_view'

class SavedList extends BaseView
  itemTemplate: require './templates/saved_dashboards/item'
  listTemplate: require './templates/saved_dashboards/list'

  render: =>
    @$el.html @listTemplate()

    @collection?.each (dashboard) =>

      item =
        id: dashboard.id
        name: dashboard.get('name')
        lastModified: dashboard.get('last_modified')

      @$el.find('.dashboards').append @itemTemplate(item)
    @

module.exports = SavedList