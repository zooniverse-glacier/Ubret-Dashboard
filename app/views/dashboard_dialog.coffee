BaseView = require 'views/base_view'
Manager = require 'modules/manager'

class DashboardDialog extends BaseView
  className: 'dialog'
  tag: 'div'

  projects: require 'config/projects_config'

  template: require './templates/dashboard_dialog'

  initialize: (options) ->
    @parent = options.parent
    @selected = Manager.get('project')

  events: 
    'click span.window-close' : 'close'
    'click button.close' : 'close'
    'click button.new-dashboard' : 'newDashboard'

  render: =>
    @$el.html @template(@)
    @

  close: =>
    @remove()

  newDashboard: =>
    name = @$('input#name').val()
    project = @$('select#project_type').val()
    @parent.createDashboard(name, project)
    @close()

module.exports = DashboardDialog