BaseView = require 'views/base_view'
Params = require 'collections/params'

class MyDataLists extends BaseView
  noProjectTemplate: require './templates/no_project_template'
  zooniverse: require 'collections/zooniverse_subjects'
  params: new Params [{key: 'limit', val: 10}]
  manager: require 'modules/manager'

  url: =>
    @manager.get('sources').get('1')
      .get('search_types')[@type].url

  reset: =>
    return unless @collection
    @collection.reset()

  loadCollection: =>
    return if !@manager.get('project') or @manager.get('project') is 'default'
    unless @collection?
      @collection = new @zooniverse [],
        params: @params
        type: @type
        url: @url()
    @collection.fetch().done @render

  render: =>
    if not _.isUndefined @collection
      @$el.html @template
        type: @type
        name: @name
        project: @manager.get('project')
        tools: require('config/toolset_config').projects[@manager.get('project')].defaults.join('-')
      @collection.each (model) =>
        @$('.my-data-list').append @templateItem(model.toJSON())
    else
      @$el.html @noProjectTemplate()
    @

module.exports = MyDataLists
