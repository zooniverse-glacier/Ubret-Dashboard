Settings = require 'collections/settings'

class SubjectSettings extends Backbone.View
  tagName: 'div'
  className: 'subject-settings'
  template: require './templates/subject_settings'

  events:
    'click .nav .prev' : 'onSelectPrevSubject'
    'click .nav .next' : 'onSelectNextSubject'

  initialize: ->
    # Backbone.Mediator.subscribe("#{@model.get('channel')}:keys", @setKeys)

  render: =>
    @$el.append @template
    @


  #Events
  onSelectPrevSubject: (e) =>
    console.log @model.get 'selectedElement'
    # @model.set 'selectedElement', $(e.currentTarget).val()

  onSelectNextSubject: (e) =>
    console.log @model.get 'selectedElement'
    # @model.set 'selectedElement', $(e.currentTarget).val()

module.exports = SubjectSettings