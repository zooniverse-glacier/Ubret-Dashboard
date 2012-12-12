BaseModel = require 'models/base_model'

class Subject extends BaseModel

  initialize: ->
    @set 'uid', _.uniqueId('subject_')

module.exports = Subject