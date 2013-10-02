var AppView = require('views/app_view'),
  Router = require('lib/router'),
  Api = require('lib/api'),
  Header = require('views/header'),
  UserTalkCollections = require('collections/user_talk_collections'),
  Login = zooniverse.controllers.loginDialog,
  UserDashboards = require('collections/user_dashboards'),
  UserZooDataCollections = require('collections/user_zoo_data_collections');

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
      User.current.promises.dashboards = User.current.dashboards.fetch();
      User.current.promises.collections = User.current.collections.fetch();
      User.current.promises.zooData = User.current.zooData.fetch();
    }
  };

  User.on('change', toggleLoggin);

  User.on('change', function(response) {
    if (!User.current && 
        ((state.get('page') !== "dashboard") && (state.get('page') !== 'examine'))) {
      app.active.hide();
      Login.show();
      return;
    } else if (!User.current && 
               ((state.get('page') === "dashboard") || (state.get('page') === 'examine'))) {
      return;
    }
    User.current.collections = new UserTalkCollections();
    User.current.zooData = new UserZooDataCollections();
    User.current.dashboards = new UserDashboards();
    User.current.promises = {collections: null, zooData: null, dashboards: null};
    User.trigger('initialized');
    updateUser();
  });

  var promise = User.fetch();
  window.router = new Router(promise);

  var state = require('lib/state'),
    topBar = new zooniverse.controllers.TopBar(),
    app = new AppView({model: state}),
    header = new Header({model: state});

  Backbone.Events.listenTo(state, 'change:project', updateUser);

  topBar.el.appendTo(document.body);


  Backbone.history.start();
};
