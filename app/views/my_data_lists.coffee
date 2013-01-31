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
    # This is super ugly figure out a better way to do this.
    dashboard = new Dashboard
      name: "New Dashboard from #{@type}"
      project: Manager.get('project')

    dashboard.save().done =>
      firstToolType = Manager.get('default_toolset')[0]
      secondToolType = Manager.get('default_toolset')[1]
      dashboard.on 'sync:tools', (tool) =>
        console.log 'here'
        tool.get('data_source').save
            source: 2
            source_type: 'external'
            search_type: 'favs/recents'
            params: new Params [
              key: 'type' 
              val: @type
            ,
              key: 'limit'
              val: 20
            ,
              key: 'project'
              val: Manager.get('project')
            ]

        Manager.get('router').navigate "#/dashboards/#{dashboard.id}", {trigger: true}

      dashboard.get('tools').add [
        tool_type: firstToolType
        name: "#{@type} #{firstToolType}"
        channel: "#{firstToolType}-1"
      ,
        tool_type: secondToolType
        name: "#{@type} #{secondToolType}"
        channel: "#{secondToolType}-2"
      ]



module.exports = MyDataLists
