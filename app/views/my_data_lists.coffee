BaseView = require 'views/base_view'
Manager = require 'modules/manager'
User = require 'lib/user'
Params = require 'collections/params'

class MyDataLists extends BaseView
  noProjectTemplate: require './templates/no_project_template'

  loadCollection: =>

  render: =>
    if not _.isUndefined @collection
      @$el.html @template({type: @type, project: Manager.get('project')})
      @collection.each (model) =>
        @$('.my-data-list').append @templateItem(model.toJSON())
    else
      @$el.html @noProjectTemplate()
    @

module.exports = MyDataLists
