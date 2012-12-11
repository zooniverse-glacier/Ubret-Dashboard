BaseView = require 'views/base_view'
Manager = require 'modules/manager'

class AppHeader extends BaseView
  template: require './templates/layout/header'

  events:
    'click .create-dashboard': 'onCreateDashboard'
    'click nav a': 'onNavigate'

  render: =>
    @$el.html @template()
    @

  onNavigate: (e) =>
    $(e.currentTarget).addClass('active')

  onCreateDashboard: (e) =>
    Backbone.Mediator.publish 'dashboard:create'
    
module.exports = AppHeader