BaseView = require 'views/base_view'
Manager = require 'modules/manager'
User = require 'user'
Login = require 'views/login'

class AppHeader extends BaseView
  template: require './templates/layout/header'

  events:
    'click .create-dashboard': 'onCreateDashboard'

  subscriptions:
    'router:dashboardCreate': 'onViewCurrent'
    'dashboard:initialized' : 'updateLink'
    'router:dashboardRetrieve': 'onViewCurrent'
    'router:viewSavedDashboards': 'onViewSaved'

  initialize: ->
    User.on 'sign-in', @render
    @login = new Login
    @active = ''
    @id = ''

  rendered: false

  render: =>
    @$el.html @template({id: @id})
    console.log @active
    if @active is 'current'
      @$('li a.my-dashboards').removeClass 'active'
      @$('li a.current').addClass 'active'
    else if @active is 'saved'
      @$('li a.my-dashboards').addClass 'active'
      @$('li a.current').removeClass 'active'
    else
      @$('li a.my-dashboards').removeClass 'active'
      @$('li a.current').removeClass 'active'
    @assign
      '.login' : @login
    @

  onViewCurrent: =>
    @active = 'current'

  onViewSaved: =>
    @active = 'saved'

  onCreateDashboard: (e) =>
    Backbone.Mediator.publish 'dashboard:create'

  updateLink: (model) =>
    @id = model.id

  # Helpers
  removeActive: =>
    $('nav.main-nav').find('.active').each (i) ->
      $(@).removeClass('active')

    
module.exports = AppHeader