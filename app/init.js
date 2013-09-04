var AppView = require('views/app_view'),
  Router = require('lib/router'),
  Api = require('lib/api'),
  Header = require('views/header'),
  UserTalkCollections = require('collections/user_talk_collections'),
  UserDashboards = require('collections/user_dashboards');

module.exports = function() {
  var User = zooniverse.models.User;
 
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
    if (User.current && state.get('project')) {
      User.current.dashboards.fetch();
      User.current.collections.fetch();
    }
  };

  var state = require('lib/state'),
    topBar = new zooniverse.controllers.TopBar(),
    app = new AppView({model: state}),
    header = new Header({model: state});

  window.router = new Router(state, User);

  topBar.el.appendTo(document.body);

  User.on('change', toggleLoggin);

  Backbone.Events.listenTo(state, 'change:project', updateUser);

  User.fetch()
  User.on('change', function(response) {
    if (!User.current)
      return;
    User.current.collections = new UserTalkCollections();
    User.current.dashboards = new UserDashboards();
    User.trigger('initialized');
    updateUser();
  });

  Backbone.history.start();
};
