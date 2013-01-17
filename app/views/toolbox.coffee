BaseView = require 'views/base_view'
Manager = require 'modules/manager'
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
    'tools:loaded': 'render'

  render: =>
    @tools = []
    for tool in Manager.get 'tools'
      @tools.push {name: Ubret[tool]::name, class_name: tool} if Ubret[tool]::name

    @$el.html @template {available_tools: @tools}
    @

  createTool: (e) =>
    e.preventDefault()
    toolType = $(e.currentTarget).attr('name')
    @trigger 'create', toolType

  removeTools: (e) =>
    e.preventDefault()
    @trigger 'remove-tools'

  toggleSaved: (e) =>
    e.preventDefault()
    @savedList.$el.toggleClass 'active'


module.exports = Toolbox