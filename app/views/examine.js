var State = require('lib/state');

var Examine = Backbone.View.extend({
  className: 'examine-mode',
  template: require('templates/examine'),
  padding: 160,
  spacing: 25,

  initialize: function() {
    State.on('change:examineMode change:page', this.render, this);
  },

  height: function(length) {
    return window.innerHeight - (2 * this.padding);
  },

  width: function(length) {
    if (length === 1) 
      return window.innerWidth - (2 * this.padding);
    else
      return (window.innerWidth - (2 * this.padding)) / 2 - this.spacing;
  },

  render: function(s) {
    mode = s.get('examineMode');
    if (!mode)
      return;

    var ids = State.get('examine')
      tools = State.get('currentDashboard').get('tools'),
      tools = tools.filter(function(t) {return !( -1 === _.indexOf(ids, t.id))}),
      length = tools.length,
      height = this.height(length),
      width = this.width(length),
      url = "#/" + s.get('project') + "/dashboards/" + s.get('currentDashboardId');

    this.$el.html(this.template({url: url})); 

    d3.select(this.el).select('.tools').style('width', window.innerWidth + "px");
    var examineWindows = d3.select(this.el).select('.tools').selectAll('.container')
      .data(tools, function(d) { return d.id });

    examineWindows.enter().append('div')
      .attr('class', 'container')
      .style('height', height + "px")
      .style('width', width + "px")

    examineWindows.append('h2').text(function(d) { return d.get('name')})

    examineWindows.append(function(d) { 
      d.getUbretTool().setSize(height, width);
      d.getUbretTool().delegateEvents();
      return d.getUbretTool().el; 
    });

  }
});

module.exports = Examine;
