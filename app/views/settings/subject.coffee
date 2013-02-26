BaseView = require 'views/base_view'

class SubjectSettings extends BaseView
  tagName: 'div'
  className: 'subject-settings'
  template: require 'views/templates/settings/subject'

  events:
    'click .nav .prev' : 'prev'
    'click .nav .next' : 'next'

  render: =>
    @$el.html @template(@model.toJSON())
    @

  #Events
  prev: =>
    @model.tool.trigger 'prev'
    
  next: =>
    @model.tool.trigger 'next'

module.exports = SubjectSettings