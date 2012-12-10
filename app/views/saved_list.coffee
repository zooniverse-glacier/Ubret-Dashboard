BaseView = require 'views/base_view'

class SavedList extends BaseView
  tagName: "ul"
  className: "saved-list"
  template: require './templates/saved_dashboard'

  render: =>
    @collection?.each (dashboard) => 
      console.log dashboard

      item =
        id: dashboard.id
        name: dashboard.get('name')
        lastModified: dashboard.get('last_modified')

      console.log item
      @$el.append @template(item)
    @

module.exports = SavedList
