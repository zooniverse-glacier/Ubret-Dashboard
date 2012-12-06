BaseView = require 'views/base_view'

SavedList = require 'views/saved_list'
User = require 'user'

class Toolbox extends BaseView
  tagName: 'div'
  className: 'toolbox'
  template: require './templates/toolbox'

  events: 
    'click a.tool' : 'createTool'
    'click a.remove-tools' : 'removeTools' 
    'click a.saved-dashboards' : 'toggleSaved'

  subscriptions:
    'dashboard:initialized': 'onDashboardInit'

  initialize: ->
    User.on 'sign-in', @loadSaved
    @tools = []
    @db_state = false
    for name, tool of Ubret
      @tools.push {name: tool::name, class_name: name} if tool::name

  render: =>
    @$el.html @template {available_tools: @tools, db_state: @db_state}
    # @$el.append @savedList.render().el if typeof @savedList isnt 'undefined'
    @

  createTool: (e) =>
    e.preventDefault()
    toolType = $(e.currentTarget).attr('name')
    @trigger 'create', toolType

  removeTools: (e) =>
    e.preventDefault()
    @trigger "remove-tools"

  toggleSaved: (e) =>
    e.preventDefault()
    @savedList.$el.toggleClass 'active'

  loadSaved: =>
    User.current.on 'loaded-dashboards', =>
      @savedList = new SavedList { collection: User.current.dashboards }
      @render()

  onDashboardInit: =>
    @db_state = true
    @render()

module.exports = Toolbox
