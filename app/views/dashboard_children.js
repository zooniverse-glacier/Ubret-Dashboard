var Children = require('collections/dashboard_children');

var DashboardChildren = Backbone.View.extend(_.extend({
  el: "#children",
  template: require('templates/saved_list'),
  state: require('lib/state'),

  events: {
    'click .layouts button' : 'setListType',
  },

  initialize: function() {
    this.collection = new Children();
    this.state.on('change:currentDashboardId', this.update, this);
    this.listenTo(this.state, 'change:list-type', this.setListClass);
    this.setListClass(this.state, this.state.get('list-type'));
  },

  updateName: function(state) {
    var name = state.get('currentDashboard').get('name');
    this.$('.dashboard-name').text(name);
  },

  update: function(state) {
    this.collection.id = state.get('currentDashboardId');
    this.updateName(state);
    this.collection.fetch().done(_.bind(function() {
      this.render();
      this.$('.delete').hide();
    }, this));
  }

}, require('views/toggle'), require('views/toggle_list')));

module.exports = DashboardChildren