var User = zooniverse.models.User;

var Data = Backbone.View.extend(_.extend({
  el: '#data',
  state: require('lib/state'),

  template: require('templates/data_list'),

  events: {
    'click .layouts button' : 'setListType',
  },

  initialize: function() {
    User.on('initialized', _.bind(function() {
      this.collection = User.current.collections;
      this.listenTo(this.collection, 'add reset', this.render);
    }, this));
    this.listenTo(this.state, 'change:list-type', this.setListClass);
    this.setListClass(this.state, this.state.get('list-type'));
  }
}, require('views/toggle'), require('views/toggle_list')));

module.exports = Data;
