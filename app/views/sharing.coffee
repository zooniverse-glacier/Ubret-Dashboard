BaseView = require 'views/base_view'

class Sharing extends BaseView
  template: require './templates/sharing'
  className: 'sharer'

  events:
    'click a.url' : 'showUrl'

  dashboardHref: ->
    console.log @model
    "http://tools.zooniverse.org/#/dashboards/#{@model.get('project')}/#{@model.id}"

  facebookHref: ->
    title = @model.get('name')
    summary = "I just make this Dashboard on ZooTools"
    """
      https://www.facebook.com/sharer/sharer.php
      ?s=100
      &p[url]=#{encodeURIComponent @dashboardHref()}
      &p[title]=#{encodeURIComponent title}
      &p[summary]=#{encodeURIComponent summary}
    """

  twitterHref: ->
    message = "Exploring Zooniverse data with ZooTools! #{@dashboardHref()} via @zootools"
    "http://twitter.com/home?status=#{encodeURIComponent message}"

  render: =>
    opts =
      url: @dashboardHref()
      twitter: @twitterHref()
      facebook: @facebookHref()
    @$el.html @template(opts)
    @

  showUrl: (e) =>
    e.preventDefault()
    @$el.toggleClass 'active-url'
    @$('input').focus().select()

module.exports = Sharing