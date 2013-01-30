BaseView = require 'views/base_view'
Manager = require 'modules/manager'
Subjects = require 'collections/subjects'
User = require 'user'
Params = require 'collections/params'
Dashboard = require 'models/dashboard'

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
    @loadDashboard()

  loadDashboard: =>
    dashboard = new Dashboard
      name: "New Dashboard from #{@type}"
      project: Manager.get('project')

    console.log dashboard

module.exports = MyDataLists
