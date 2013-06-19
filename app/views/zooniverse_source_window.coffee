Window = require 'views/window'

class ZooniverseSourceWindow extends Window
  className: 'tool-window zooniverse-window'
  listTemplate: require './templates/zooniverse_source_window_list'

  events: 
    'click a.remove' : 'removeId'
    'click .id-list li' : 'selectId'

  initialize: ->
    super
    @model.on 'change:data_source.params[0].val', @render

  render: =>
    super
    @$('.container').html @listTemplate
      zoo_ids: @model.get('data_source.params[0].val')
      selected: @model.get('selected_uids') or []
    @

  removeId: (e) =>
    e.preventDefault()
    id = e.target.dataset.id
    if id in (@model.get('selected_uids') or [])
      @model.tool.selectIds id
    @model.updateFunc('data_source.params[0].val',
      _.clone(_.without(@model.get('data_source.params[0].val'), id)))

  selectId: (e) =>
    return if e.target.className is 'remove'
    @$(e.target).toggleClass 'selected'
    id = e.target.dataset.id
    @model.tool.selectIds id


module.exports = ZooniverseSourceWindow
