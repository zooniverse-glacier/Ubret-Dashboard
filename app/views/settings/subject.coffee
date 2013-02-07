BaseView = require 'views/base_view'

class SubjectSettings extends BaseView
  tagName: 'div'
  className: 'subject-settings'
  template: require 'views/templates/settings/subject'

  events:
    'click .nav .prev' : 'onSelectPrevSubject'
    'click .nav .next' : 'onSelectNextSubject'

  render: =>
    @$el.html @template
    @

  #Events
  onSelectPrevSubject: =>
    @model.tool.trigger 'prev'
    
  onSelectNextSubject: =>
    @model.tool.trigger 'next'

module.exports = SubjectSettings