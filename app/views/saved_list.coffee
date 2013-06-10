BaseView = require 'views/base_view'

class SavedList extends BaseView
  itemTemplate: require './templates/saved_dashboards/item'
  listTemplate: require './templates/saved_dashboards/list'
  user: require 'lib/user'
  sharing: require 'views/sharing'

  events:
    'click a.delete': 'deleteDashboard'
    'click a.share': 'shareDashboard'

  initialize: ->
    @collection.on 'reset remove', @reset
    @collection.on 'reset remove', @render
    @reset()

  reset: =>
    @sharers = {}
    @collection.each (dashboard) =>    
      @sharers[dashboard.id] = new @sharing {model: dashboard}

  render: =>
    @$el.html @listTemplate()
    @$('.dashboards').height window.innerHeight - 200
    console.log @$('.dashboards').height()

    @collection.each (dashboard) =>
      item =
        id: dashboard.id
        name: dashboard.get('name')
        project: dashboard.get('project')
        lastModified: new Date(dashboard.get('updated_at')).toLocaleString()
      @$('.dashboards').append @itemTemplate(item)
    @

  shareDashboard: (e) =>
    e.preventDefault()
    @openSharer e.currentTarget.dataset.id, e.currentTarget

  openSharer: (id, target) =>
    @$('.sharer').remove()
    if id is @openId
      @openId = null
    else
      @$(target).parent().append @sharers[id].render().el
      @openId = id

  deleteDashboard: (e) =>
    e.preventDefault()
    @removeDashboard e.currentTarget.dataset.id, e.currentTarget

  removeDashboard: (id, target) =>
    @collection.remove id
    delete @sharers[id]
    @user.current.removeDashboard id, ->
      $(target).parents().eq(3).remove()

module.exports = SavedList