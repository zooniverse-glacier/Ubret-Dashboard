BaseView = require 'views/base_view'

class TablePageSettings extends BaseView
  className: 'table-settings'
  template: require 'views/templates/table_settings'

  events:
    'click button.next' : 'nextPage'
    'click button.prev' : 'prevPage'

  initialize: ->
    @page = @model.get('settings').get('currentPage') or 0

  render: =>
    @$el.html @template()
    @

  nextPage: =>
    @page = @page + 1
    @model.get('settings').set 'currentPage', @page

  prevPage: =>
    @page = @page - 1
    @model.get('settings').set 'currentPage', @page

module.exports = TablePageSettings

