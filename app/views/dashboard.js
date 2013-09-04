Dashboard = Backbone.View.extend(_.extend({
  el: '#dashboard',

  initialize: function() {
    User.on('initialized', _.bind(function() {
      this.collection = User.current.dashboards;
    }, this));
    this.listenTo(Dashboard.State, 'change:currentDashboard', this.updateDashboard);
    this.model = Dashboard.State.get('currentDashboard');
    if (this.model) {
      this.sidebarTree = new Dashboard.SimpleTreeView({model: this.model}).render();
      this.render();
    }
  },

  treeLayout: d3.layout.tree(),

  render: function() {
    if (!this.model)
      return;
    var treeLayout = _.map(this.model.get('tools').toTree(), this.treeLayout);
  },

  updateDashboard: function(state, model) {
    this.$(".section-header h2").text(model.get('name'));
    this.model = model;
    this.sidebarTree == new Dashboard.SimpleTreeView({model: this.model}).render();
    this.render();
  }
}, require('views/toggle_view')));

module.exports = Dashboard;
