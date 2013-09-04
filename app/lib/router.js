Router = Backbone.Router.extend({
  routes: {
    '': 'index',
    ':project(/)' : 'setProject',
    ':project/dashboards(/)' : 'showSaved',
    ':project/data(/)' : 'showData',
    ':project/dashboards/new(/)' : 'newDashboard',
    ':project/dashboards/:id(/)' : 'showDashboard',
    ':project/dashboards/:id/children(/)' : 'showDashboardChildren',
    ':project/dashboards/:id/copy(/)' : 'copyDashboard',
    ':project/subjects/:subjects(/:name)' : 'dashboardFromSubjects',
    ':project/collections/:colletions(/:name)' : 'dashboardFromCollections' 
  },

  initialize: function(state, user) {
    this.state = state;
    this.user = user;
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

  newDashboard: function(project) {
    this.setProjectState(project);
    this.setPage('new');
  },

  showDashboard: function(project, id) {
    this.setProjectState(project);
    this.setPage('dashboard');
    if (User.current.dashboards) {
      this.state.set('currentDashboard', User.current.dashboards.get(id));
    } else {
      var dashboardModel = new Dashboard.Dashboard({id: id})
      dashboardModel.fetch().then(_.bind(function() {
        this.state.set('currentDashboard', dashboardModel);
      }, this));
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
