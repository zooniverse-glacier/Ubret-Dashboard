Manager = require 'modules/manager'

class GoogleSubjectCollection extends Backbone.Collection
  model: require 'models/subject'
  sync: Backbone.tabletopSync

  initialize: (models=[], options={}) ->
    @tabletop =
      sheet: options.sheet
      instance: options.tabletop
      
  comparator: (subject) ->
    subject.get('uid')

module.exports = GoogleSubjectCollection
