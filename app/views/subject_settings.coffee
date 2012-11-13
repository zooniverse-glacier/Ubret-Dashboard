
class SubjectSettings extends Backbone.View
  tagName: 'div'
  className: 'subject-settings'
  template: require './templates/subject_settings'

  events:
    'click .nav .prev' : 'onSelectPrevSubject'
    'click .nav .next' : 'onSelectNextSubject'

  initialize: ->
    Backbone.Mediator.subscribe("#{@model.get('channel')}:keys", @setKeys)

  render: =>
    @$el.append @template
    @

  setKeys: (keys) =>
    @keys = keys
    @render()


  #Events
  onSelectPrevSubject: =>
    unless @model.get('selectedElements') # Wrong
      @model.set('selectedElements', [@model.get('dataSource').get('data').models[0].get('id')])
    else
      currentIds = @model.get('selectedElements')
      currentSubject = _.find @model.get('dataSource').get('data').models, (datum) ->
        datum.get('id') == currentIds[0]

      currentSubjectIndex = _.indexOf @model.get('dataSource').get('data').models, currentSubject
      if currentSubjectIndex is 0
        newIndex = @model.get('dataSource').get('data').length - 1
      else
        newIndex = currentSubjectIndex - 1

      @model.set('selectedElements', [@model.get('dataSource').get('data').models[newIndex].get('id')])

  onSelectNextSubject: =>
    unless @model.get('selectedElements') # Wrong
      @model.set('selectedElements', [@model.get('dataSource').get('data').models[0].get('id')])
    else
      currentIds = @model.get('selectedElements')
      currentSubject = _.find @model.get('dataSource').get('data').models, (datum) ->
        datum.get('id') == currentIds[0]

      currentSubjectIndex = _.indexOf @model.get('dataSource').get('data').models, currentSubject
      if currentSubjectIndex is @model.get('dataSource').get('data').length - 1
        newIndex = 0
      else
        newIndex = currentSubjectIndex + 1

      @model.set('selectedElements', [@model.get('dataSource').get('data').models[newIndex].get('id')])


module.exports = SubjectSettings