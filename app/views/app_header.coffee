BaseView = require 'views/base_view'

class AppHeader extends BaseView
  user: require 'lib/user'
  loginBar: require 'views/login'

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
    @user.on 
      'sign-in': @render
      'sign-out': @render
    @login = new @loginBar

  render: =>
    @$el.html @template()
    if @dashId then @$('.current').attr 'href', '/#/dashboards/' + @dashId

    if @user.current? 
      @$('.create-dashboard').removeAttr 'disabled'
      @$('.fork-dashboard').show() if @isForkable()
    else
      @$('.fork-dashboard').hide()
      @$('.create-dashboard').attr 'disabled', 'disabled'

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
    @dashId = model.id
    @render()

module.exports = AppHeader