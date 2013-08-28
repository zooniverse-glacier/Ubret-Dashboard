(function() {
  var Dashboard = this.Dashboard;
   
  this.initialize = function() {
    var topBar = new zooniverse.controllers.TopBar(),
      app = new Dashboard.App({model: Dashboard.State}),
      header = new Dashboard.Header({model: Dashboard.State});

    Dashboard.router = new Dashboard.Router(Dashboard.State, User);

    topBar.el.appendTo(document.body);

    User.on('change', Dashboard.toggleLoggin);

    Backbone.Events.listenTo(Dashboard.State, 'change:project', Dashboard.updateUser);

    User.fetch().then(function() {
      User.current.collections = new Dashboard.UserCollections();
      User.current.dashboards = new Dashboard.UserDashboards();
      User.trigger('initialized');
    }).then(Dashboard.updateUser);

    Backbone.history.start();
  };

}).call(this);
