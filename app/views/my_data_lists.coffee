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
    @manager.get('sources').get('1')
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
    @collection.fetch().then @render

  render: =>
    if not _.isUndefined @collection
      tools = @projects[@manager.get('project')]
        .defaults.join('-')
      @$el.html @template
        type: @type
        name: @name
        project: @manager.get('project')
        tools: tools
      @collection.each (model) =>
        @$('.my-data-list').append @templateItem(model.toJSON())
    else
      @$el.html @noProjectTemplate()
    @

module.exports = MyDataLists
