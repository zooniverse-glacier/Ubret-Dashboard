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
      return _.map(response.my_collections, function(col) {
        return {
          title: col.title,
          zooniverse_id: col.zooniverse_id,
          subjects: _.pluck(col.subjects, 'zooniverse_id'),
          image: col.subjects[0].location.standard,
          thumbnail: col.subjects[0].location.thumbnail,
          description: col.description
        };
      });
    }
  });
}).call(this);
