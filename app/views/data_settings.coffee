class DataSettings extends Backbone.View
  tagName: 'div'
  className: 'data-settings'
  template: require './templates/data_settings'

  extSources:
    'Galaxy Zoo': 'Galaxy Zoo Subjects'

  events:
    'click .type-select a.external' : 'showExternal'
    'click .type-select a.internal' : 'showInternal'
    'click button[name="fetch"]'    : 'updateModel'

  initialize: (options) ->
    @dataSource = @model.get('dataSource')
    @channel = @model.get('channel')
    @sourceType = false

    # Data events
    @dataSource.on 'change:source', @render
    @dataSource.on 'change:params', @setParams
    Backbone.Mediator.subscribe 'all-tools', @updateToolList, @

    # Cleanup
    @model.on 'remove', @remove

  render: =>
    extSources = @extSources
    intSources = @intSources or []
    @$el.html @template
      extSources: extSources
      intSources: intSources
      source: @dataSource?.get('source')
      sourceType: @sourceType
    @

  remove: =>
    Backbone.Mediator.unsubscribe 'all-tools', @updateToolList, @

  showExternal: =>
    @sourceType = 'external'
    @render()

  showInternal: =>
    @sourceType = 'internal'
    @render()

  updateModel: =>
    if @sourceType is 'external'
      source = @$('select.external-sources').val()
      params = new Object
      @$('.external-settings input').each (index) ->
        name = $(this).attr('name')
        value = $(this).val()
        params[name] = value
      @dataSource.set 'params', params
      @dataSource.set 'source', source
    else
      source = @$('select.internal-sources').val()
      @dataSource.set 'source', source
    @dataSource.fetchData()

  updateToolList: (list) =>
    @intSources = new Array
    @intSources.push item for item in list when item.channel isnt @channel
    @render()


module.exports = DataSettings