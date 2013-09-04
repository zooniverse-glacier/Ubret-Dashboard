var Header = Backbone.View.extend({
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

module.exports = Header;
