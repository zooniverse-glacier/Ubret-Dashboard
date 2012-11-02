class Table extends Backbone.View
  template: require './templates/table'
  tagName: 'table'
  className: 'table-tool'
  ubretTable: Ubret.Table
  nonDisplayKeys: ['id']

  render: =>
    @$el.html @template()
    @table = new @ubretTable(@dataKeys(), @model.get('dataSource').get('data').toJSON(), "table##{@id}")
    @

  dataKeys: =>
    dataModel = @model.get('dataSource').get('data').at(0).toJSON()
    keys = new Array
    for key, value of dataModel
      keys.push key unless key in @nonDisplayKeys
    return keys

module.exports = Table
