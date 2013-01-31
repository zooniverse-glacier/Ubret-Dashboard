BaseView = require 'views/base_view'
ToolWindow = require 'views/tool_window'
Tool = require 'models/tool'

class ToolView extends BaseView
  template: require 'views/templates/tool_view'

  subscriptions:
    'router:showTool' : 'showTool'

  initialize: () =>
    @model = new Tool {saveable: false}
    @model.on 'change', @fetchTool

  fetchTool: =>
    $.getJSON '/tools.json', (tools) =>
      tool = tools.scripts[@model.get('tool_type')]
      scripts = new Array
      scripts.push tools.scripts[dep].source for dep in tool.dependencies
      scripts.push tool.source
      yepnope
        load: scripts 
        complete: @render

  showTool: (dash_id, tool_id) =>
    @model.set
      dashboard_id: dash_id
      id: tool_id
    ,
      silent: true
    @model.fetch()

  render: =>
    @$el.html @template(@model.toJSON())
    @toolWindow = new ToolWindow({model: @model, el: @$('.tool-window')}).render()
    @model.get('data_source').fetchData()
    @

module.exports = ToolView
