BaseView = require 'views/base_view'
Manager = require 'modules/manager'
Subjects = require 'collections/subjects'
User = require 'user'
Params = require 'collections/params'

class MyDataLists extends BaseView
  noProjectTemplate: require './templates/no_project_template'
  events:
    'click button' : 'handleEvent'

  loadCollection: =>
    if Manager.get('project')
      @collection = new Subjects [],
        url: Manager.get('sources').get(2).get('url')
        params: new Params [{key: 'type', val: @type}, 
                            {key: 'limit', val: 10},
                            {key: 'project', val: Manager.get('project')}]
      @collection.on 'add reset', @render
      @collection.fetch()

  render: =>
    if not _.isUndefined @collection
      @$el.html @template()
      @collection.each (model) =>
        @$('.recents').append @templateItem(model.toJSON())
    else
      @$el.html @noProjectTemplate()
    @

  handleEvent: (e) =>
    project = Manager.get('project')
    Manager.get('router').navigate "#/project/#{project}/Dashboard-from-#{@type}/Table-SubjectViewer/2-0/type_#{@type}-limit_20-project_#{project}"

module.exports = MyDataLists
