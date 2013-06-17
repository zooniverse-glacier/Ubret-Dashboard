BaseView = require 'views/base_view'
Params = require 'collections/params'

class ZooniverseDataSettings extends BaseView
  tagName: 'div'
  className: 'zooniverse-data-settings'
  template: require 'views/templates/settings/zooniverse_data'
  user: require 'lib/user'
  zooSubjects: require 'collections/zooniverse_subjects'

  initialize: ->
    if @user.current?
      @initializeCollection()
    else
      @user.on 'sign-in', @initializeCollection

  initializeCollection: =>
    @talkCollections = @user.current.collections
    @talkCollections.on 'add reset', @render
    @talkCollections.fetch()

  events:
    'click .sources ul a' : 'displaySource'
    'click button.import' : 'importData'
    'change input[name="recent-count"]' : 'updateRecentCount'
    'change input[name="favorite-count"]' : 'updateFavCount'

  render: =>
    super
    @$el.html @template
      collections: @talkCollections.toJSON()
    @

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
    collection = @$('.user-collection option:selected').val()
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

module.exports = ZooniverseDataSettings
