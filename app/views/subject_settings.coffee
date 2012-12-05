BaseView = require 'views/base_view'

class SubjectSettings extends BaseView
  tagName: 'div'
  className: 'subject-settings'
  template: require './templates/subject_settings'

  events:
    'click .nav .prev' : 'onSelectPrevSubject'
    'click .nav .next' : 'onSelectNextSubject'

  initialize: ->
    Backbone.Mediator.subscribe("#{@model.get('channel')}:keys", @setKeys)

  render: =>
    @$el.html @template
    @

  setKeys: (keys) =>
    @keys = keys
    @render()

  #Events
  onSelectPrevSubject: =>
    

  onSelectNextSubject: =>


module.exports = SubjectSettings