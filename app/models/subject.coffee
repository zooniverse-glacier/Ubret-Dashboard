AppModel = require 'models/app_model'

class Subject extends AppModel

  initialize: ->
    @set 'uid', _.uniqueId('subject_')

module.exports = Subject