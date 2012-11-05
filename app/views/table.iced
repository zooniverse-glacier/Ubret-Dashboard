class Table extends Backbone.View
  template: require './templates/table'
  noDataTemplate: require './templates/no_data'
  tagName: 'table'
  className: 'table-tool'
  ubretTable: Ubret.Table
  nonDisplayKeys: ['id']

  render: =>
    data = @model.getData() 
    if data.length is 0
      @$el.html @noDataTemplate()
    else
      @$el.html @template()
      @table = new @ubretTable(@dataKeys(), _.each( data, (datum) -> datum.toJSON ), "table##{@id}")
    @

  dataKeys: (data) =>
    dataModel = data[0].toJSON()
    keys = new Array
    for key, value of dataModel
      keys.push key unless key in @nonDisplayKeys
    return keys

module.exports = Table
