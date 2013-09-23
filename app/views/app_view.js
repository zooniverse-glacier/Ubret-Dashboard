var Dashboard = require('views/dashboard'),
  Saved = require('views/saved_list'),
  Data = require('views/data_list'),
  User = zooniverse.models.User;

var App = Backbone.View.extend({
  el: "#app",

  sections: {
    index: require('views/index_dialog'),
    new: require('views/create_dashboard_dialog'),
    dashboard: new Dashboard(),
    saved: new Saved(),
    data: new Data()
  },

  initialize: function() {
    this.active = this.$('#index');
    this.listenTo(this.model, 'change:page', this.setActive);
    this.listenTo(this.model, 'change:project', this.redirect);
    User.on('change', _.bind(this.setActive, this));
  },

  setActive: function(state, active) {
    if (_.isString(active)) {
      this.active.hide();
      this.active = this.sections[active];
    }
    if ((active === 'dashboard') || User.current)
      this.active.show();
  }
});

module.exports = App;
