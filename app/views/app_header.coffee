BaseView = require 'views/base_view'
Manager = require 'modules/manager'
User = require 'user'
Login = require 'views/login'

class AppHeader extends BaseView
  template: require './templates/layout/header'

  events:
    'click .create-dashboard': 'onCreateDashboard'

  subscriptions:
    'dashboard:initialized': 'updateLink'
    'router:dashboardCreate': 'onViewCurrent'
    'router:dashboardRetrieve': 'onViewCurrent'
    'router:viewSavedDashboards': 'onViewSaved'

  initialize: ->
    User.on 'sign-in', @render
    @login = new Login
    @$el.html @template()

  render: =>
    if @id then @$('.current').attr 'href', '/#/dashboards/' + @id

    @removeActive()
    switch @active
      when 'current' then @$('li a.current').addClass 'active'
      when 'saved' then @$('li a.my-dashboards').addClass 'active'

    @assign '.login', @login
    @

  onViewCurrent: =>
    @active = 'current'
    @render()

  onViewSaved: =>
    @active = 'saved'
    @render()

  onCreateDashboard: (e) =>
    Backbone.Mediator.publish 'dashboard:create'

  updateLink: (model) =>
    @id = model.id
    @render()

  # Helpers
  removeActive: =>
    $('nav.main-nav').find('.active').each (i) ->
      $(@).removeClass('active')

    
module.exports = AppHeader