Window = require 'views/window'
Params = require 'collections/params'

class ZooniverseSourceWindow extends Window
  template: require './templates/zooniverse_source_window'
  listTemplate: require './templates/zooniverse_source_window_list'
  zooSubjects: require 'collections/zooniverse_subjects'
  user: require 'lib/user'

  events:
    'click .sources ul a' : 'displaySource'
    'click button.import' : 'importData'
    'click a.remove' : 'removeId'
    'click .id-list li' : 'selectId'
    'change input[name="recent-count"]' : 'updateRecentCount'
    'change input[name="favorite-count"]' : 'updateFavCount'

  initialize: ->
    super
    @talkCollections = @user.current.collections
    @talkCollections.on 'add reset', @render
    @model.on 'change:data_source', @renderList
    @talkCollections.fetch()

  render: =>
    super
    @$el.addClass 'zooniverse-window'
    @$('.settings').remove()
    @$('.container').html @template
      collections: @talkCollections.toJSON()
    @renderList()
    @

  renderList: =>
    @$('.id-list').html @listTemplate
      zoo_ids: @model.get('data_source.params[0].val')
      selected: @model.get('selected_uids')

  displaySource: (e) =>
    e.preventDefault()
    @activeDiv.removeClass('active') if @activeDiv
    @activeTarget = e.target.dataset.target
    @activeDiv = @$(".#{@activeTarget}").addClass('active')

  importData: (e) =>
    @$('.loading').show()
    switch @activeTarget
      when 'collections'
        xhr = @importCollection()
      when 'favorites'
        xhr = @import('favorite')
      when 'recents'
        xhr = @import('recent')
      when 'ids'
        xhr = @importIds()
    if xhr.then?
      xhr.then => @$('.loading').hide()
    else
      @$('.loading').hide()

  importCollection: =>
    collection = @$('.user-colleciton option:selected').val()
    if collection is '' or not collection?
      collection = @$('input[name="collection-id"]').val() 

    new @zooSubjects([], {type: 'collection', id: collection})
      .fetch().then (collection) =>
        zooIDs = _.map collection.subjects, (s) -> s.zooniverse_id
        @model.updateFunc('data_source.params[0].val', 
          _.uniq(zooIDs.concat(@model.get('data_source.params[0].val'))))

  import: (type) =>
    limit = @$("input[name=\"#{type}-count\"]").val()
    params = new Params [{key: 'limit', val: limit}]

    new @zooSubjects([], {type: type, params: params})
      .fetch().then (subjects) =>
        zooIDs = _.map subjects, (s) => s.subjects[0].zooniverse_id
        @model.updateFunc('data_source.params[0].val',
          _.uniq(zooIDs.concat(@model.get('data_source.params[0].val'))))

  importIds: =>
    ids = @$('.zoo-ids').val().replace(/\s*/g, '').split(',')
    @model.updateFunc('data_source.params[0].val',
      _.uniq(ids.concat(@model.get('data_source.params[0].val'))))

  updateRecentCount: (e) =>
    @$('.recent-count').text e.target.value

  updateFavCount: (e) =>
    @$('.favorite-count').text e.target.value

  removeId: (e) =>
    e.preventDefault()
    id = e.target.dataset.id
    if id in @model.get('selected_uids')
      @model.tool.selectIds id
    @model.updateFunc('data_source.params[0].val',
      _.without(@model.get('data_source.params[0].val'), id))

  selectId: (e) =>
    @$(e.target).toggleClass 'selected'
    id = e.target.dataset.id
    @model.tool.selectIds id

module.exports = ZooniverseSourceWindow
