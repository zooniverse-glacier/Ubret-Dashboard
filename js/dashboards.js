(function() {
  "use strict";
  var Dashboard = this.Dashboard;
  var User = this.User;

  Dashboard.Dashboard = Backbone.AssociatedModel.extend({
    relations: [
      {
        type: Backbone.Many,
        key: 'tools',
        relatedModel: Dashboard.Tool,
        collectionType: Dashboard.Tools
      }
    ],

    sync: Dashboard.Sync,

    url: function() {
      return "/dashboards/" + this.id;
    },

    fetch: function() {
      if (!Dashboard.State.get('project'))
        return
      return Dashboard.Dashboard.__super__.fetch.call(this);
    },

    getFormattedDate: function(field) {
      var date = moment(this.get(field)),
        now = moment();
      if (date.isBefore(now.subtract('days', 2)))
        return date.format('lll');
      else if (date.isBefore(now.subtract('days', 1)))
        return 'Yesterday';
      else
        return date.fromNow();
    }
  });

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
          id: col.zooniverse_id,
          image: col.subjects[0].location.standard,
          title: col.title,
          subjects: _.pluck(col.subjects, 'zooniverse_id'),
          thumbnail: col.subjects[0].location.thumbnail,
          description: col.description
        };
      });
    }
  });

}).call(this);
