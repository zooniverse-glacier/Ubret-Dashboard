Dialog = require 'views/dialog'
Manager = require 'modules/manager'

class DashboardDialog extends Dialog
  projects: require 'config/projects_config'

  template: require './templates/dashboard_dialog'

  title: 'Create New Dashbaord'
  confirmation: 'Create Dashboard'
  confirmCallback: (e) => @newDashboard(e) 

  initialize: ->
    super
    @selected = Manager.get('project')
    
  render: =>
    super
    @content @template(@)
    @

  newDashboard: =>
    name = @$('input#name').val()
    project = @$('select#project_type').val()
    dashboard = @parent.createDashboard(name, [], project)
    dashboard.save().done =>
      @parent.dashboardModel = dashboard
      @parent.navigateToDashboard()
    @close()

module.exports = DashboardDialog