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
    if @model.get('data_source').isExternal()
      prevSubject = @model.get('data_source').data.previous(_.last(@model.get('selected_ids')))
    else
      source = @model.collection.find (tool) =>
        tool.get('channel') is @model.get('data_source').get('source')
      prevSubject = source.get('data_source').data.previous(_.last(@model.get('selected_ids')))
    @model.set 'selected_ids', [prevSubject]
    
  onSelectNextSubject: =>
    if @model.get('data_source').isExternal()
      nextSubject = @model.get('data_source').data.next(_.last(@model.get('selected_ids')))
    else
      source = @model.collection.find (tool) =>
        tool.get('channel') is @model.get('data_source').get('source')
      nextSubject = source.get('data_source').data.previous(_.last(@model.get('selected_ids')))
    @model.set 'selected_ids', [nextSubject] 

module.exports = SubjectSettings