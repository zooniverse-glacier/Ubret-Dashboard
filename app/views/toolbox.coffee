AppView = require 'views/app_view'
SavedList = require 'views/saved_list'
User = require 'user'

class Toolbox extends AppView
  tagName: 'div'
  className: 'toolbox'
  template: require './templates/toolbox'

  events: 
    'click a.tool' : 'createTool'
    'click a.remove-tools' : 'removeTools' 
    'click a.saved-dashboards' : 'toggleSaved'

  initialize: ->
    User.on 'sign-in', @loadSaved
    @tools = []
    for name, tool of Ubret
      @tools.push {name: tool::name, class_name: name} if tool::name

  render: =>
    @$el.html @template {available_tools: @tools}
    @$el.append @savedList.render().el if typeof @savedList isnt 'undefined'
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

module.exports = Toolbox
