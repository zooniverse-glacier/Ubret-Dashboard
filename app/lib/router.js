var Dashboard = require("models/dashboard"),
  State = require('lib/state'),
  User = zooniverse.models.User;

var Router = Backbone.Router.extend({
  routes: {
    '': 'index',
    ':project(/)' : 'setProject',
    ':project/dashboards(/)' : 'showSaved',
    ':project/data(/)' : 'showData',
    ':project/dashboards/new(/)' : 'newDashboard',
    ':project/dashboards/:id(/)' : 'showDashboard',
    ':project/dashboards/:id/children(/)' : 'showDashboardChildren',
    ':project/dashboards/:id/copy(/)' : 'copyDashboard',
    ':project/dashboards/:id/examine/:toolIds' : 'examineMode',
    ':project/subjects/:subjects(/:name)' : 'dashboardFromSubjects',
    ':project/collections/:collections(/:name)' : 'dashboardFromCollections'
  },

  index: function() {
    this.setProjectState('');
    this.setPage('index');
  },

  setProjectState: function(project) {
    State.set('project', project);
  },

  setPage: function(page) {
    State.set('page', page);
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

  newDashboard: function(project) {
    this.setProjectState(project);
    this.setPage('new');
  },

  showDashboard: function(project, id) {
    this.setProjectState(project);
    this.setPage('dashboard');
    State.set('examineMode', false);
    if (User.current.dashboards) {
      State.set('currentDashboard', User.current.dashboards.get(id));
      State.set('currentDashboardId', id);
    } else {
      var dashboardModel = new Dashboard({id: id})
      return dashboardModel.fetch().then(_.bind(function() {
        State.set('currentDashboard', dashboardModel);
        State.set('currentDashboardId', dashboardModel.id);
      }, this));
    }
  },

  examineMode: function(project, id, ids) {
    var promise = this.showDashboard(project, id);
    if (!promise) { 
      State.set('examine', ids.split(','));
      State.set('examineMode', true);
    } else {
      promise.then(_.bind(function() {
        State.set('examine', ids.split(','));
        State.set('examineMode', true);
      }, this))
    }
  },

  dashboardFromSubjects: function(project, subjects, name) {
    this.setProjectState(project);
  },

  dashboardFromCollections: function(project, collections, name) {
    this.setProjectState(project);
  }
});

module.exports = Router;
