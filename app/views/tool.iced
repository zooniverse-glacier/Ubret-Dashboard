
class UbretTool extends Backbone.View
  tagName: 'tool'
  className: 'ubret-tool'

  initialize: ->
    @tool_events = []

  render: =>
    data = @model.getData()

    opts =
      data: _.each( data, (datum) -> datum.toJSON )
      selector: "#{@toolType}##{@id}"

    @tool = new Ubret[@toolType](opts)

    # Parse attributes
    _.each @tool.attributes, (attr) =>
      @model.set attr, attr.default
      # Setup events for attribute, if any
      if typeof attr.events is 'object'
        _.each attr.events, (event) =>
          @model.on "#{event.selector}", "#{event.action}:#{attr}", (e) =>
            @model.set attr, event.callback(@model.get(attr))

    @

  selectById: (id) ->

    @model.set 'currentSubject', @id

  dataKeys: (data) =>
    dataModel = data[0].toJSON()
    keys = new Array
    for key, value of dataModel
      keys.push key unless key in @nonDisplayKeys
    return keys

module.exports = UbretTool