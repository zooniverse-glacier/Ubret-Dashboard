BaseView = require 'views/base_view'

class TablePageSettings extends BaseView
  className: 'table-settings'
  template: require 'views/templates/settings/table'

  events:
    'click button.next' : 'nextPage'
    'click button.prev' : 'prevPage'

  initialize: ->
    @page = @model.get('settings').get('currentPage') or 0

  render: =>
    @$el.html @template()
    @

  nextPage: =>
    @model.tool.trigger 'next-page'

  prevPage: =>
    @model.tool.trigger 'prev-page'

module.exports = TablePageSettings

