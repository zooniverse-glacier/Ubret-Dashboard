BaseView = require 'views/base_view'

class DownloadData extends BaseView
  tagName: 'div'
  className: 'download-data-settings'
  template: require 'views/templates/settings/download_data'

  events: 
    'click button' : 'downloadData'

  render: =>
    super
    @$el.html @template()
    @

  downloadData: =>
    $.ajax
      type: 'POST'
      data: JSON.stringify(@model.tool.preparedData())
      url: 'https://jcvd.herokuapp.com/to-csv'
      crossDomain: true
      dataType: 'json'
      contentType: 'application/json'
      success: @downloadIframe

  downloadIframe: (data) ->
    $('body').append("""<iframe src="https://jcvd.herokuapp.com/to-csv/#{data.data_url}" style="display: none;"></iframe>""")

module.exports = DownloadData
