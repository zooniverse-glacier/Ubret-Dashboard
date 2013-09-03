(function() {
  "use strict";
  var Dashboard = this.Dashboard;

  Dashboard.App = Backbone.View.extend({
    el: "#app",

    sections: {
      index: Dashboard.IndexDialog,
      new: Dashboard.CreateDialog,
      dashboard: new Dashboard.DashboardView,
      saved: new Dashboard.Saved, 
      data: new Dashboard.Data
    },

    initialize: function() {
      this.active = this.$('#index');
      this.listenTo(this.model, 'change:page', this.setActive);
      this.listenTo(this.model, 'change:project', this.redirect);
    },

    setActive: function(state, active) {
      var section = this.sections[active];
      if (_.isUndefined(section))
        throw new Error("Section doesn't exist");
      this.active.hide();
      this.active = this.sections[active];
      this.active.show();
    }
  });

  Dashboard.Menu = Backbone.View.extend({
    el: '#global-menu',

    events: {
      'click li' : 'navigateTo'
    },

    pages: {
      'saved' : '#saved-dashboards',
      'dashboard' : '#current-dashboard',
      'data' : '#saved-data'
    },

    initialize: function() {
      this.menuItems = this.$('a');
      this.listenTo(this.model, 'change:project', this.updateProject);
      this.listenTo(this.model, 'change:page', this.updateActive);
      this.listenTo(this.model, 'change:currentDashboard', this.updateDashboard);
    },

    updateDashboard: function(state, dashboard) {
      if (!dashboard) {
        this.$('#copy-dashboard, #current-dashboard').addClass('disabled');
        return;
      }
      this.$('#copy-dashboard, #current-dashboard').removeClass('disabled');
    },

    updateActive: function(state, page) {
      if (this.active)
        this.active.removeClass('active');
      this.active = this.$(this.pages[page]);
      this.active.addClass('active');
    },

    navigateTo: function(ev) {
      var navigate = _.bind(function(destination) {
        Dashboard.router.navigate('#/' + this.model.get('project') + destination, { trigger: true })
      }, this);

      ev = $(ev.target);

      if (ev.hasClass('disabled'))
        return;
      else if (ev.attr('id') === 'saved-dashboards')
        navigate('/dashboards');
      else if (ev.attr('id') === 'saved-data')
        navigate('/data');
      else if (ev.attr('id') === 'current-dashboard')
        navigate('/dashboards/' + this.model.get('currentDashboard').id);
      else if (ev.attr('id') === 'new-dashboard')
        navigate('/dashboards/new');
      else if (ev.attr('id') === 'copy-dashboard')
        this.model.get('currentDashboard').copy().then(function(response) {
          navigate('/dashboards/' + response)
        });

      $('#menu').toggleClass('active');
      this.toggle();
    },

    toggle: function() {
      this.$el.toggleClass('active');
    }
  });

  Dashboard.Header = Backbone.View.extend({
    el: "header",
    active: null,

    events: {
      "click #current-project" : 'toggleProjects',
      "click #menu" : "toggleMenu"
    },

    initialize: function() {
      this.activeProject = this.$('#current-project .name');
      this.projectSelect = this.$('#project-select');
      this.menu = new Dashboard.Menu({model: this.model});
      this.listenTo(this.model, 'change:project', this.updateProject);
      this.listenTo(this.model, 'change:page', this.updatePageHeader);
      this.listenTo(this.model, 'change:currentDashboard', this.updatePageHeader);
    },

    toggleProjects: function() {
      this.projectSelect.toggle();
    },

    updatePageHeader: function() {
      var page = this.model.get('page');
      var dashboard = this.model.get('currentDashboard');
      if (page === 'dashboard' && !_.isUndefined(dashboard)) {
        this.$('#dashboard-controls').show();
        this.$('#current-dashboard').show()
          .text(dashboard.get("name"));
      } else {
        this.$('#current-dashboard').hide();
        this.$('#dashboard-controls').hide();
      }
    },

    toggleMenu: function() {
      this.$('#menu').toggleClass('active');
      this.menu.toggle();
    },

    updateProject: function(state, project) {
      var projectText;
      // Hide Project Select in case it's open
      this.projectSelect.hide();

      // Update the Active Project
      if (!project) {
        projectText = 'No Project';
      } else {
        // Hide the Active Project from the List
        if (!_.isUndefined(this.hiddenProject))
          this.hiddenProject.show(); 
        this.hiddenProject = this.projectSelect.find('#' + project).hide();
        projectText = Dashboard.projects[project].name;
      }
      this.activeProject.text(projectText);
    }
  });
}).call(this);
