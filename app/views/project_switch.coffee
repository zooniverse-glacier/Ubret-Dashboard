BaseView = require 'views/base_view'

class ProjectSwitch extends BaseView
  manager: require 'modules/manager'
  projects: require 'config/projects_config'
  template: require './templates/project_switch'

  initialize: ->
    _.extend @, Backbone.Events
    @on 'project-change', @render

  events:
    'click li.project' : 'updateManager'
    'click .active-project' : 'activateDropdown'

  activateDropdown: (e) =>
    @$('ul.dropdown').toggleClass 'active'

  updateManager: (e) =>
    @manager.set('project', e.currentTarget.dataset.project)
    @$('ul.dropdown').removeClass 'active'
    @trigger 'project-change'

  render: =>
    projects = _.omit @projects, @manager.get('project')
    @$el.html @template
      projects: projects
      current: @projects[@manager.get('project')].name
    @

module.exports = ProjectSwitch
