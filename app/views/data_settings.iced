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
    @model?.on 'change:source', @setSource
    @model?.on 'change:params', @setParams
    @channel = options?.channel
    Backbone.Mediator.subscribe 'all-tools', @updateToolList

  render: =>
    extSources = @extSources
    intSources = @intSources or []
    @$el.html @template({extSources: extSources, intSources: intSources, source: @model?.get('source')})
    @

  showExternal: =>
    @$('.internal-settings').hide()
    @$('.external-settings').show()
    @$('button[name="fetch"]').show()
    @external = true

  showInternal: =>
    @$('.internal-settings').show()
    @$('.external-settings').hide()
    @$('button[name="fetch"]').show()
    @external = false 

  updateModel: =>
    if @external
      source = @$('select.external-sources').val()
      params = new Object
      @$('.external-settings input').each (index) ->
        name = $(this).attr('name')
        value = $(this).val()
        params[name] = value
      @model.set 'params', params
      @model.set 'source', source
    else
      source = @$('select.internal-sources').val()
      @model.set 'source', source
    @model.fetchData()

  setSource: =>
    source = @model.get('source')
    if @model.isExternal
      console.log 'here'

  updateToolList: (list) =>
    @intSources = new Array
    @intSources.push item for item in list when item.channel isnt @channel
    @render()

module.exports = DataSettings
