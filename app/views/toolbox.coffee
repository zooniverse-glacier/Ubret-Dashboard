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
    'dblclick .dashboard-name' : 'editName'
    'keypress input' : 'updateName'
    'blur input' : 'updateName'

  subscriptions:
    'dashboard:initialized': 'render'

  render: =>
    @tools = []
    for tool in Manager.get 'tools'
      @tools.push {name: Ubret[tool]::name, class_name: tool} if Ubret[tool]::name

    @$el.html @template {available_tools: @tools, name: @model?.get('name') or 'Untitled'}
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

  editName: (e) =>
    name = @$('.dashboard-name')
    input = @$('input')
    name.hide()
    input.show()

  updateName: (e) =>
    if e.type is 'focusout' or e.which is 13
      name = @$('.dashboard-name')
      input = @$('input')
      newTitle = input.val()
      if newTitle is @model.get('name')
        name.show() 
        input.hide()
      else
        name.text newTitle
        @model.save 'name', newTitle
        name.show()
        input.hide()

module.exports = Toolbox