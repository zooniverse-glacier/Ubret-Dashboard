var Menu = require('views/menu'),
  Projects = require('config/projects');

var ProjectMenu = Menu.extend({
  el: "#project-menu",

  events: {
    'click li':  'changeProject'
  },

  initialize: function(options) {
    this.parent = options.parent;
  },

  render: function() {
    var projects = _.map(Projects, function(c, p) {return [p, c.name]; });
    projectli = d3.select(this.el).select('ul').selectAll('li')
      .data(projects, function(d) { return d[0]; });

    projectli.enter().append('li')
      .attr('data-project', function(d) { return d[0] })
      .text(function(d) { return d[1]; });

    return this;
  },

  changeProject: function(ev) {
    var project = ev.target.dataset.project
    window.router.navigate(this.projectUrl(project), {trigger: true});
    $('#menu').toggleClass('active');
    this.$el.removeClass('active');
    this.parent.toggle();
  },

  projectUrl: function(d) {
    return "#/" + d;
  }
});

module.exports = ProjectMenu;
