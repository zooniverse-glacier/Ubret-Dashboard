User = require 'user'
DashboardModel = require 'models/dashboard'
DashboardView = require 'views/dashboard'
Toolbox = require 'views/toolbox'

class AppView
  constructor: ->
    @toolbox = new Toolbox { el: '.toolbox' } unless @toolbox?
    @toolbox.render()
    @toolboxEvents()

  createDashboard: (id) ->
    args = if typeof id isnt 'undefined' then { id: id } else { }
    @dashboardModel = new DashboardModel args
    fetcher = @dashboardModel.fetch() if typeof id isnt 'undefined'
    fetcher.success(=> 
      @dashboardView = new DashboardView { model: @dashboardModel, el: '.dashboard' }
      @dashboardView.render()) if fetcher?

  toolboxEvents: =>
    @toolbox.on 'create', @addTool
    @toolbox.on 'remove-tools', @removeTools

  addTool: (tool_type) =>
    @dashboardModel.createTool tool_type

  removeTools: =>
    @dashboardModel.removeTools()
  
module.exports = AppView
