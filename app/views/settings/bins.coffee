BaseView = require 'views/base_view'

class BinSettings extends BaseView
  tagName: 'div'
  className: 'graph-settings'
  template: require 'views/templates/settings/bins'

  events:
    'change .bins' : 'updateBins'

  render: =>
    @$el.html @template({bins: @model.get('settings').get('bins') or 0})
    @

  updateBins: (e) =>
    bins = @$('input.bins').val()
    bins = null if bins is '0' or bins is '1' or bins is ''

    @model.tool.settings({bins: bins}) unless bins is ''
    @render()
 
module.exports = BinSettings
