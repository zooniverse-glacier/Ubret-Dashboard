var App = Backbone.View.extend({
  el: "#app",

  sections: {
    index: Dashboard.IndexDialog,
    new: Dashboard.CreateDialog,
    dashboard: new Dashboard.DashboardView,
    saved: new Dashboard.Saved, 
    data: new Dashboard.Data
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
