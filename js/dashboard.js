(function() {
  "use strict";
  var root = this;
  root.Dashboard = {};
  root.User = zooniverse.models.User;

  var Dashboard = root.Dashboard;
  var User = root.User;

  Dashboard.Api = new zooniverse.Api();

  Dashboard.State = new Backbone.Model({
    'list-type' : 'list',
    'project' : false
  });

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
    return (User.current && Dashboard.State.get('project'));
  };

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

  Dashboard.updateUser = function() {
    if (Dashboard.userAndProject()) {
      User.current.dashboards.fetch();
      User.current.collections.fetch();
    }
  };
}).call(this);
