BaseView = require 'views/base_view'
Params = require 'collections/params'

class MyDataLists extends BaseView
  noProjectTemplate: require './templates/no_project_template'
  loadingTemplate: require './templates/loading'
  zooniverse: require 'collections/zooniverse_subjects'
  manager: require 'modules/manager'
  projects: require 'config/projects_config'

  params: new Params [{key: 'limit', val: 10}]

  url: =>
    @manager.get('sources').get('zooniverse')
      .search_types[@type].url

  reset: =>
    return unless @collection
    @collection.reset()

  loadCollection: =>
    unless @collection?
      @collection = new @zooniverse [],
        params: @params
        type: @type
        base: @url()
    @render()
    @$('.my-data-list').html @loadingTemplate()
    @collection.reset()
    @collection.fetch().then @render

  dashboardUrl: (project, ids, name) =>
    "#/project/#{project}/objects/#{ids.join(',')}/Dashboard-from-#{name}"

  render: =>
    if not _.isUndefined @collection
      ids = @collection.map (i) -> i.get('uid')
      tools = @projects[@manager.get('project')]
        .defaults.join('-')
      @$el.html @template
        url: @dashboardUrl(@manager.get('project'), ids, @name)
      @collection.each (model) =>
        @$('.my-data-list').append @templateItem(model.toJSON())
    else
      @$el.html @noProjectTemplate()
    @

module.exports = MyDataLists
