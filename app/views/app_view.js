var Dashboard = require('views/dashboard'),
  Saved = require('views/saved_list'),
  Data = require('views/data_list');

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
  },

  setActive: function(state, active) {
    var section = this.sections[active];
    if (_.isUndefined(section))
      throw new Error("Section doesn't exist");
    this.active.hide();
    this.active = this.sections[active];
    this.active.show();
  }
});

module.exports = App;
