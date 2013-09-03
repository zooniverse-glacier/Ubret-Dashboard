(function() {
  "use strict";

  var Dashboard = this.Dashboard;

  Dashboard.IndexPage = Backbone.View.extend({
    className: 'dashboard-welcome-view',
    template: _.template($('#welcome-overlay').html()),

    initialize: function() {
      this.projectName = this.$('.name');
      this.listenTo(Dashboard.State, 'change:project', this.updateProjectView);
      this.listenTo(Dashboard.State, 'change:project', this.render);
      this.dashboardCreate = new Dashboard.Create();
      User.on('initialized', _.bind(function() {
        this.collection = User.current.dashboards;
        this.render();
        this.listenTo(this.collection, 'add reset', this.updateRecents);
      }, this));
    },

    events: {
      'change select.project' : 'setProject'
    },

    setProject: function(ev) {
      if (ev.target.value === '')
        return;
      else
        Dashboard.router.navigate("#/" + ev.target.value, {trigger: true});
    },

    updateProjectView: function() {
      if (Dashboard.State.get('project')) {
        this.$('.project-selected').show();
        this.$('.no-project').hide();
      } else {
        this.$('.project-selected').hide();
        this.$('.no-project').show();
      }
    },

    listProjects: function() {
      var projectList = [['', {name: 'Projects'}]]
        .concat(_.pairs(Dashboard.projects))

      var projectSelect = d3.select(this.el).select('.project').selectAll('option')
        .data(projectList, function(d) { return d[0]; });

      projectSelect.enter().append('option')
        .attr('value', function(d) { return d[0]; })
        .text(function(d) { return d[1].name; });

      projectSelect.exit().remove();
    },

    updateRecents: function() {
      var recents = d3.select(this.el).select('#welcome-recents').selectAll('li')
        .data(this.collection.models.slice(0,3), function (d) { return d.id });
     
      recents.enter().append('li')
        .append('a')
        .attr('href', function(d) { 
          return "#/" + d.get('project') + "/dashboards/" + d.id 
        })
        .html(function(d) { 
          var name = '<span class="name">' + d.get('name') + '</span>';
          var data = '<span class="date">' + d.getFormattedDate('updated_at') + '</span>'
          return name + data;
        });

      recents.exit().remove();
    },

    render: function() {
      if (!User.current)
        return;

      // Render Welcome Template
      this.$el.html(this.template({project: Dashboard.State.get('project')}));
      this.$('#welcome-create').html(this.dashboardCreate.render().el);
      this.$('#welcome-create .exit').hide();
      this.updateProjectView();

      if (!_.isEmpty(User.current.dashboards))
        this.updateRecents();

      if (!Dashboard.State.get('projects'))
        this.listProjects();

      return this;
    }
  });

  Dashboard.IndexDialog = new zooniverse.controllers.Dialog({
    content: new Dashboard.IndexPage().$el
  });
}).call(this);
