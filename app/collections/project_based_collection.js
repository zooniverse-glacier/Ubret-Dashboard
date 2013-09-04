var User = zooniverse.models.User;

var ProjectBasedCollection = Backbone.Collection.extend({
  initialize: function() {
    User.on('change', _.bind(this.fetch, this));
    this.listenTo(require('lib/state'), 'change:project', this.fetch);
  },

  sync: require('lib/sync'), 

  comparator: function(m) {
    return -(new Date(m.get('updated_at')).getTime());
  },

  fetch: function() {
    if (!(User.current && require('lib/state').get('project')))
      return;
    return ProjectBasedCollection.__super__.fetch.call(this);
  }
});

module.exports = ProjectBasedCollection;
