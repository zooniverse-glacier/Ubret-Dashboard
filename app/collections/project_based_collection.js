ProjectBasedCollection = Backbone.Collection.extend({
  initialize: function() {
    User.on('change', _.bind(this.fetch, this));
    this.listenTo(Dashboard.State, 'change:project', this.fetch);
  },

  sync: Dashboard.Sync,

  comparator: function(m) {
    return -(new Date(m.get('updated_at')).getTime());
  },

  fetch: function() {
    if (!Dashboard.userAndProject())
      return
    return Dashboard.ProjectBasedCollection.__super__.fetch.call(this);
  }
});

module.exports = ProjectBasedCollection;
