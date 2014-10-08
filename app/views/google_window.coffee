Window = require 'views/window'

class GoogleWindow extends Window
  className: 'tool-window quench-window data-source-window'
  googleTemplate: require './templates/google_window'

  events:
    'click button' : 'fetchData'

  render: =>
    super
    @$('.container').html @googleTemplate(@model.get('data_source').toJSON())
    selected = @model.get('data_source.search_type')
    @$("[data-collection=\"#{selected}\"]").addClass 'selected'
    @

  fetchData: (e) =>
    @selectBox or= @$('select')
    @model.set('data_source.search_type', @selectBox.val())

module.exports = GoogleWindow
