DashboardModel = require 'models/dashboard'
DashboardView = require 'views/dashboard'
Toolbox = require 'views/toolbox'

class Router extends Backbone.Router
  routes:
    ''              : 'index'
    'dashboard/:id' : 'retrieveDashboard'

  index: =>
    @dashboardModel = new DashboardModel
    @dashboard = new DashboardView { model: @dashboardModel, el: '.dashboard' }
    @toolbox = new Toolbox { el: '.toolbox' } unless @toolbox?

    @dashboard.render()
    @toolbox.render()
    @toolboxEvents()

  retrieveDashbaord: (id) =>
    @dashboardModel = new DashboardModel { id: id }
    @dashboardModel.fetch()
    @dashboard = new DashboardView { model: @dashboardModel, el: '.dashboard' }
    @toolbox = new Toolbox { el: '.toolbox' } unless @toolbox?

    @dashboard.render()
    @toolbox.render()
    @toolboxEvents()

  toolboxEvents: =>
    @toolbox.on 'create', @addTool
    @toolbox.on 'remove-tools', @removeTools

  addTool: (tool_type) =>
    @dashboardModel.createTool tool_type

  removeTools: =>
    @dashboardModel.removeTools()
  

module.exports = Router
