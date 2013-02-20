BaseView = require 'views/base_view'

class BinSettings extends BaseView
  tagName: 'div'
  className: 'graph-settings'
  template: require 'views/templates/settings/bins'

  events:
    'keyup .bins' : 'updateBins'

  render: =>
    @$el.html @template({bins: @model.get('settings').get('bins')})
    @

  updateBins: (e) =>
    bins = @$('input.bins').val().split(',')
    bins[index] = value.replace(/\s+/g, '') for value, index in bins
    bins = bins[0] if bins.length is 1
    bins = null if bins is '0' or bins is '1' or bins is ''

    @model.tool.settings({bins: bins}).start() unless bins is ''
 
module.exports = BinSettings
