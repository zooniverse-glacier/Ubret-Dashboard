module.exports = function() {
  var toggleLoggin = function(event, user) {
    if (_.isNull(user)) { 
      $('.logged-out').show();
      $('.logged-in').hide();
    } else {
      $('.logged-out').hide();
      $('.logged-in').show();
    }
  }

  var updateUser = function() {
    if (Dashboard.userAndProject()) {
      User.current.dashboards.fetch();
      User.current.collections.fetch();
    }
  };

  var topBar = new zooniverse.controllers.TopBar(),
    app = new Dashboard.App({model: Dashboard.State}),
    header = new Dashboard.Header({model: Dashboard.State});

  Dashboard.router = new Dashboard.Router(Dashboard.State, User);

  topBar.el.appendTo(document.body);

  User.on('change', Dashboard.toggleLoggin);

  Backbone.Events.listenTo(Dashboard.State, 'change:project', Dashboard.updateUser);

  User.fetch()
  User.on('change', function(response) {
    if (!User.current)
      return;
    User.current.collections = new Dashboard.UserCollections();
    User.current.dashboards = new Dashboard.UserDashboards();
    User.trigger('initialized');
    Dashboard.updateUser();
  });

  Backbone.history.start();
};
