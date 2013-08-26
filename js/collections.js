(function() {
  "use strict";
  var Dashboard = this.Dashboard;
  var User = this.User;

  Dashboard.ProjectBasedCollection = Backbone.Collection.extend({
    initialize: function() {
      User.on('change', _.bind(this.fetch, this));
      this.listenTo(Dashboard.State, 'change:project', this.fetch);
    },

    sync: Dashboard.Sync,

    fetch: function() {
      if (!Dashboard.userAndProject())
        return
      return Dashboard.ProjectBasedCollection.__super__.fetch.call(this);
    }
  });

  Dashboard.UserDashboards = Dashboard.ProjectBasedCollection.extend({
    model: Dashboard.Dashboard, 

    url: "/dashboards"
  });

  Dashboard.UserCollections = Dashboard.ProjectBasedCollection.extend({
    url: function() {
      return "/talk/users/" + User.current.id + "?type=my_collections";
    },

    parse: function(response) {
      return response.my_collections;
    }
  });
}).call(this);
