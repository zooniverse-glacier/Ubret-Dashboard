User = require 'user'

BaseView = require 'views/base_view'

DashboardModel = require 'models/dashboard'
DashboardView = require 'views/dashboard'

AppHeader = require 'views/app_header'
Toolbox = require 'views/toolbox'

class AppView extends BaseView
  template: require './views/templates/layout/app'

  initialize: ->
    @appHeader = new AppHeader
    @toolbox = new Toolbox

    @$el.html @template()
    @render()

    @toolbox.on 'create', @addTool
    @toolbox.on 'remove-tools', @removeTools

  render: =>
    @assign
      '.app-header': @appHeader
      '.toolbox': @toolbox
    @

  createDashboard: (id) ->
    args = if typeof id isnt 'undefined' then { id: id } else { }
    @dashboardModel = new DashboardModel args
    fetcher = @dashboardModel.fetch() if typeof id isnt 'undefined'
    fetcher.success(=> 
      @dashboardView = new DashboardView { model: @dashboardModel, el: '.dashboard' }
      @dashboardView.render()) if fetcher?

  addTool: (tool_type) =>
    @dashboardModel.createTool tool_type

  removeTools: =>
    @dashboardModel.removeTools()
  
module.exports = AppView
