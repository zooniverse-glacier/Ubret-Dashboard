BaseView = require 'views/base_view'
Manager = require 'modules/manager'

class AppHeader extends BaseView
  template: require './templates/layout/header'

  events:
    'click .create-dashboard': 'onCreateDashboard'

  render: =>
    @$el.html @template()
    @

  onCreateDashboard: (e) =>
    Backbone.Mediator.publish 'dashboard:create'
    
module.exports = AppHeader