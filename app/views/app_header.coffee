BaseView = require 'views/base_view'
Manager = require 'modules/manager'
User = require 'user'
Login = require 'views/login'

class AppHeader extends BaseView
  template: require './templates/layout/header'

  events:
    'click .create-dashboard': 'onCreateDashboard'

  subscriptions:
    'router:index': 'onViewCurrent'
    'router:dashboardCreate': 'onViewCurrent'
    'router:dashboardRetrieve': 'onViewCurrent'
    'router:viewSavedDashboards': 'onViewSaved'

  initialize: ->
    User.on 'sign-in', @render
    @login = new Login

  rendered: false

  render: =>
    @$el.html @template()
    @assign
      '.login' : @login
    @

  onViewCurrent: =>
    @removeActive()
    $('nav.main-nav').find('.current').addClass('active')

  onViewSaved: =>
    @removeActive()
    $('nav.main-nav').find('.my-dashboards').addClass('active')

  onCreateDashboard: (e) =>
    Backbone.Mediator.publish 'dashboard:create'

  # Helpers
  removeActive: =>
    $('nav.main-nav').find('.active').each (i) ->
      $(@).removeClass('active')

    
module.exports = AppHeader