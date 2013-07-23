Window = require 'views/window'

class QuenchWindow extends Window
  className: 'tool-window quench-window data-source-window'
  quenchTemplate: require './templates/quench_window'

  events:
    'click button' : 'fetchData'

  render: =>
    super
    @$('.container').html @quenchTemplate()
    selected = @model.get('data_source.search_type')
    @$("[data-collection=\"#{selected}\"]").addClass 'selected'
    @

  fetchData: (e) =>
    @model.set('data_source.search_type', e.target.dataset.collection)

module.exports = QuenchWindow
