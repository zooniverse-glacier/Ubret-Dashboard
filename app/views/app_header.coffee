BaseView = require 'views/base_view'
Manager = require 'modules/manager'
User = require 'user'
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
    User.on 'sign-in', @render
    @login = new Login
    @$el.html @template()

  render: =>
    if @id then @$('.current').attr 'href', '/#/dashboards/' + @id

    if @isForkable() and (not _.isUndefined(User.current.dashboards))
      @$('.fork-dashboard').show()
    else
      @$('.fork-dashboard').hide()

    @removeActive()
    switch @active
      when 'current' then @$('li a.current').addClass 'active'
      when 'saved' then @$('li a.my-dashboards').addClass 'active'
      when 'mydata' then @$('li a.my-data').addClass 'active'

    @assign '.login', @login
    @

  isForkable: =>
    location.hash.split('/')[1] is 'dashboards' and
      _.isUndefined(User.current?.dashboards?.find (dashboard) ->
        dashboard.id is parseInt(location.hash.split('/')[2]))

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