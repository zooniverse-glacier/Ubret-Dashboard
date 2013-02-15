BaseView = require 'views/base_view'
Manager = require 'modules/manager'
Subjects = require 'collections/subjects'
User = require 'user'
Params = require 'collections/params'

class MyDataLists extends BaseView
  noProjectTemplate: require './templates/no_project_template'

  loadCollection: =>
    if Manager.get('project') or (Manager.get('project') is 'default')
      @collection = new Subjects [],
        url: Manager.get('sources').get(2).get('url')
        params: new Params [{key: 'type', val: @type}, 
                            {key: 'limit', val: 10},
                            {key: 'project', val: Manager.get('project')},
                            {key: 'api', val: if location.port < 1024 then 'api' else 'dev'}]
      @collection.on 'add reset', @render
      @collection.fetch()

  render: =>
    if not _.isUndefined @collection
      @$el.html @template({type: @type, project: Manager.get('project')})
      @collection.each (model) =>
        @$('.my-data-list').append @templateItem(model.toJSON())
    else
      @$el.html @noProjectTemplate()
    @

module.exports = MyDataLists
