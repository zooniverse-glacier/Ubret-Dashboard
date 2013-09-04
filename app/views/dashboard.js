var User = zooniverse.models.User;

var Dashboard = Backbone.View.extend(_.extend({
  el: '#dashboard',
  state: require('lib/state'),

  initialize: function() {
    User.on('initialized', _.bind(function() {
      this.collection = User.current.dashboards;
    }, this));
    this.listenTo(this.state, 'change:currentDashboard', this.updateDashboard);
    this.model = this.state.get('currentDashboard');
    if (this.model) 
      this.render();
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
    this.render();
  }
}, require('views/toggle')));

module.exports = Dashboard;
