class Table extends Backbone.View
  template: require './templates/table'
  noDataTemplate: require './templates/no_data'
  tagName: 'table'
  className: 'table-tool'
  ubretTable: Ubret.Table
  nonDisplayKeys: ['id']

  initialize: ->
    @model?.get('dataSource').on 'change:source', =>
      @model.get('dataSource').get('data').on 'reset', @render

  render: =>
    data = @model.getData() 
    if data.length is 0
      @$el.html @noDataTemplate()
    else
      @$el.html @template()
      formattedData = _.map( data, (datum) -> datum.toJSON() ) 
      console.log formattedData
      @table = new @ubretTable(@dataKeys(data), formattedData, "table##{@id}")
    @

  dataKeys: (data) =>
    dataModel = data[0].toJSON()
    keys = new Array
    for key, value of dataModel
      keys.push key unless key in @nonDisplayKeys
    return keys

module.exports = Table
