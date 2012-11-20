SubjectCollection = require './subject_collection'
SimbadSubject = require 'models/simbad_subject'

class SimbadSubjects extends SubjectCollection
  initialize: (models=[], options={}) ->
    super models, options

  model: SimbadSubject

  url: =>
    "/simbad?#{@processParams()}"

module.exports = SimbadSubjects
