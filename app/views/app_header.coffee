BaseView = require 'views/base_view'
Manager = require 'modules/manager'
User = require 'lib/user'
Login = require 'views/login'

class AppHeader extends BaseView
  template: require './templates/layout/header'

  events:
    'click .create-dashboard': 'onCreateDashboard'
    'click .fork-dashboard' : 'forkDashboard'

  subscriptions:
    'dashboard:initialized': 'updateLink'
    'router:dashboardCreate': 'onViewCurrent'
    'router:dashboardRetrieve': 'onViewCurrent'
    'router:viewSavedDashboards': 'onViewSaved'
    'router:myData' : 'onViewMyData'

  initialize: ->
    User.on 
      'sign-in': @render
      'sign-out': @render
    @login = new Login

  render: =>
    @$el.html @template()
    if @id then @$('.current').attr 'href', '/#/dashboards/' + @id

    if User.current? 
      @$('.create-dashboard').removeAttr 'disabled'
      @$('.fork-dashboard').show() if @isForkable()
    else
      @$('.fork-dashboard').addClass 'active'
      @$('.create-dashboard').attr 'disabled', 'disabled'

    @removeActive()
    switch @active
      when 'current' then @$('li a.current').addClass 'active'
      when 'saved' then @$('li a.my-dashboards').addClass 'active'
      when 'mydata' then @$('li a.my-data').addClass 'active'

    @assign '.login', @login
    @

  isForkable: =>
    location.hash.split('/')[1] is 'dashboards'

  onViewCurrent: =>
    @active = 'current'
    @render()

  onViewSaved: =>
    @active = 'saved'
    @render()

  onViewMyData: =>
    @active = 'mydata'
    @render()

  onCreateDashboard: (e) =>
    Backbone.Mediator.publish 'dashboard:create'

  forkDashboard: (e) =>
    Backbone.Mediator.publish 'dashboard:fork'

  updateLink: (model) =>
    @id = model.id
    @render()

  # Helpers
  removeActive: =>
    $('nav.main-nav').find('.active').each (i) ->
      $(@).removeClass('active')

    
module.exports = AppHeader