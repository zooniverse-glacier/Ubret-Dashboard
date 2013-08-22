(function() {
  "use strict";
  var root = this;
  root.Dashboard = {};
  var Dashboard = root.Dashboard;
  var User = zooniverse.models.User;

  Dashboard.Api = new zooniverse.Api();

  Dashboard.State = new Backbone.Model();

  Dashboard.Sync = function(method, model, options) {
    var baseURL = "https://dev.zooniverse.org/projects/" + Dashboard.State.get('project');
    options.url = baseURL + _.result(model, 'url');
    options.crossDomain = true;
    if (!_.isUndefined(User.current)) {
      options.beforeSend = function(xhr) {
        var auth = base64.encode(User.current.name + ":" + User.current.api_key);
        xhr.setRequestHeader('Authorization', "Basic: " + auth);
      };
    }
    return Backbone.sync(method, model, options);
  };

  Dashboard.userAndProject = function() {
    return (User.current && !_.isUndefined(Dashboard.State.get('project')));
  }

  Dashboard.projects = {
    galaxy_zoo: {
      name: "Galaxy Zoo"
    },
    galaxy_zoo_starburst: {
      name: "Galaxy Zoo Quench"
    },
    serengeti: {
      name: "Snapshot Serengeti"
    },
    spacewarp: {
      name: "SpaceWarps"
    }
  };

  Dashboard.UserDashboards = Backbone.Collection.extend({
    initialize: function() {
      User.on('change', _.bind(this.fetch, this));
      this.listenTo(Dashboard.State, 'change:project', this.fetch);
    },

    url: "/dashboards",

    sync: Dashboard.Sync,

    fetch: function() {
      if (!Dashboard.userAndProject())
        return
      return Dashboard.UserDashboards.__super__.fetch.call(this);
    }
  });

  Dashboard.Saved = Backbone.View.extend({
    el: "#saved",

    initialize: function() {
      this.collection = new Dashboard.UserDashboards();
      this.collection.fetch();
    }
  })

  Dashboard.App = Backbone.View.extend({
    el: "#app",

    sections: {
      index: "#index", 
      dashboard: "#dashboard", 
      saved: "#saved", 
      data: "#data"
    },

    initialize: function() {
      this.active = this.$('#index');
      this.listenTo(this.model, 'change:page', this.setActive);
    },

    setActive: function(state, active) {
      active = this.sections[active];
      if (_.isUndefined(active))
        throw new Error("Section doesn't exist");
      this.active.hide();
      this.active = this.$(active);
      this.active.show();
    }

  });

  Dashboard.Header = Backbone.View.extend({
    el: "header",
    active: null,

    sections: {
      index: null,
      dashboard: "#nav-dashboard", 
      saved: "#nav-saved", 
      data: "#nav-data"
    },

    events: {
      "click #current-project" : 'toggleProjects'
    },

    initialize: function() {
      this.activeProject = this.$('#current-project .name');
      this.projectSelect = this.$('#project-select');
      this.listenTo(this.model, 'change:project', this.updateProject);
      this.listenTo(this.model, 'change:page', this.setActive);
      this.listenTo(this.model, 'change:currentDashboard', this.setDashboard);
    },

    toggleProjects: function() {
      this.projectSelect.toggle();
    },

    setActive: function(state, active) {
      active = this.sections[active];
      if (!_.isNull(this.active))
        this.active.removeClass("active");
      if (_.isNull(active))
        this.active = null;
      this.active = this.$(active);
      this.active.addClass("active");
    },

    setDashboardHref: function(state, id) {
      curAnchor = this.$('#current-dashboard a');
      curAnchor.attr('href', curAnchor.attr('href') + "/" + id);
    },

    setDashboardName: function(state, name) {
      cur
    },

    updateProject: function(state, project) {
      // Hide Project Select in case it's open
      this.projectSelect.hide();

      // Update Anchor Tags with new Project
      var anchors = this.$('span a');
      var hrefs = _.map(anchors, function(a) { 
        var href = a.getAttribute('href');
        href = href.split('/');
        return [_.first(href), project, _.last(href)].join('/');
      });
      anchors.each(function(i) {this.setAttribute('href', hrefs[i])});

      // Update the Active Project
      if (project === '') {
        project = 'No Project';
      } else {
      // Hide the Active Project from the List
        if (!_.isUndefined(this.hiddenProject))
          this.hiddenProject.show(); 
        this.hiddenProject = this.projectSelect.find('#' + project).hide();
      }
      this.activeProject.text(Dashboard.projects[project].name);
    }
  });

  Dashboard.Router = Backbone.Router.extend({
    routes: {
      '': 'index',
      ':project' : 'setProject',
      ':project/dashboards' : 'showSaved',
      ':project/data' : 'showData',
      ':project/dashboards/:id' : 'showDashboard',
      ':project/subjects/:subjects(/:name)' : 'dashboardFromSubjects',
      ':project/collections/:colletions(/:name)' : 'dashboardFromCollections' 
    },

    initialize: function(state) {
      this.state = state;
    },

    index: function() {
      this.setProjectState('');
      this.setPage('index');
    },

    setProjectState: function(project) {
      this.state.set('project', project);
    },

    setPage: function(page) {
      this.state.set('page', page);
    },

    setProject: function(project) {
      this.setProjectState(project);
      this.setPage('index');
    },

    showSaved: function(project) {
      this.setProjectState(project);
      this.setPage('saved');
    },

    showData: function(project) {
      this.setProjectState(project);
      this.setPage('data');
    },

    showDashboard: function(project, id) {
      this.setProjectState(project);
      this.setPage('dashboard');
      this.state.set('currentDashboard', id);
    },

    dashboardFromSubjects: function(project, subjects, name) {
      this.setProjectState(project);
    },

    dashboardFromCollections: function(project, collections, name) {
      this.setProjectState(project);
    }
  });

  Dashboard.toggleLoggin = function(event, user) {
    if (_.isNull(user)) { 
      $('.logged-out').show();
      $('.logged-in').hide();
    } else {
      $('.logged-out').hide();
      $('.logged-in').show();
    }
  }

  this.initialize = function() {
    var topBar = new zooniverse.controllers.TopBar(),
      app = new Dashboard.App({model: Dashboard.State}),
      header = new Dashboard.Header({model: Dashboard.State}),
      saved = new Dashboard.Saved(),
      router = new Dashboard.Router(Dashboard.State);

    topBar.el.appendTo(document.body);

    User.on('change', Dashboard.toggleLoggin);
    User.fetch();

    Backbone.history.start();
  };

}).call(this);
