BaseView = require 'views/base_view'

class SubjectSettings extends BaseView
  tagName: 'div'
  className: 'subject-settings'
  template: require 'views/templates/subject_settings'

  events:
    'click .nav .prev' : 'onSelectPrevSubject'
    'click .nav .next' : 'onSelectNextSubject'

  render: =>
    @$el.html @template
    @

  #Events
  onSelectPrevSubject: =>
    nextSubject = @model.get('data_source').data.previous(_.last(@model.get('selectedElements')))
    @model.setElements [nextSubject]
    
  onSelectNextSubject: =>
    prevSubject = @model.get('data_source').data.next(_.last(@model.get('selectedElements')))
    @model.setElements [prevSubject] 

module.exports = SubjectSettings