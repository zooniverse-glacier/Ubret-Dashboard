BaseView = require 'views/base_view'
Manager = require 'modules/manager'
SavedList = require 'views/saved_list'

class Toolbox extends BaseView
  tagName: 'div'
  className: 'toolbox'
  template: require './templates/toolbox'
  layoutTemplate: require './templates/layout_drawer'
  user: require('lib/user')

  events: 
    'click a.tool' : 'createTool'
    'click a.layout' : 'setLayout'
    'click a.remove-tools' : 'removeTools' 
    'click a.drawer-toggle' : 'showDrawer'
    'click ul.interactions' : 'showDrawers'
    'dblclick .dashboard-name' : 'editName'
    'keypress input' : 'updateName'
    'blur input' : 'updateName'

  render: =>
    return @ unless @user.current
    @getTools()
    @getSources()

    @$el.html @template 
      available_tools: @tools 
      available_sources: @sources
      name: @model?.get('name') or 'Untitled'
    @renderLayouts()
    @

  setModel: (model) =>
    @model = model
    @model.on 'add:tools remove:tools', @renderLayouts
    @render()

  renderLayouts: =>
    @$('.layouts').html @layoutTemplate
      toolsCount: @model?.get('tools').length or 0

  getTools: =>
    @tools = []
    for tool in Manager.get 'tools'
      @tools.push {name: Ubret[tool]::name, class_name: tool} 

  getSources: =>
    @sources = []
    for source in Manager.get('sources').config[Manager.get('project')].sources
      @sources.push {name: source}

  createTool: (e) =>
    e.preventDefault()
    toolType = e.target.dataset.tool
    @trigger 'create', toolType

  setLayout: (e) =>
    e.preventDefault()
    layout = e.target.dataset.layout
    @model.trigger 'layout', layout

  removeTools: (e) =>
    e.preventDefault()
    @trigger 'remove-tools'

  editName: (e) =>
    name = @$('.name')
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

  showDrawer: (e) =>
    e.preventDefault()
    targetDrawer = @$(".#{e.target.dataset.drawer}-drawer")
    drawers = @$('.drawers')
    target = @$(e.target).parent()
    if target.hasClass 'active'
      drawers.removeClass('active')
        .children().removeClass('active')
      target.removeClass('active')
    else if drawers.hasClass 'active'
      @$('.drawer').removeClass 'active'
      targetDrawer.addClass 'active'
      target.addClass('active')
        .siblings().removeClass('active')
    else
      _.each [drawers, targetDrawer, target], (t) => t.addClass 'active'

module.exports = Toolbox