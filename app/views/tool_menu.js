var Menu = require('views/menu'),
  Window = require('views/window'),
  Tool = require('models/tool'),
  ProjectConfig = require('config/projects');

var ToolMenu = Menu.extend({
  el: "#tools-menu",

  initialize: function() {
    this.listenTo(this.model, 'change:project', this.render);
  },

  events: {
    'dragstart li': 'setDrag'
  },

  render: function() {
    var projectTools = _.pairs(ProjectConfig[this.model.get('project')].tools);
    tools = d3.select(this.el).select('.panel ul').selectAll('li')
      .data(projectTools, function(d) { return d[0]; });

    tools.enter().append('li')
      .attr('draggable', true)
      .attr('data-tool', function(d) { return d[0]; })
      .text(function(d) { return d[1]; })

    tools.exit().remove();
  },

  setDrag: function(ev) {
    var ev = ev.originalEvent,
      tool = {tool_type: 'table', name: 'New Table'};

    ev.dataTransfer.setData('application/json', JSON.stringify(tool));
    ev.dataTransfer.effectAllowed = 'copy';
  }
});

module.exports = ToolMenu;
