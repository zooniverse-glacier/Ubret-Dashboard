Data = Backbone.View.extend(_.extend({
  el: '#data',

  template: _.template($('#data-list-template').html()),

  events: {
    'click .layouts button' : 'setListType',
  },

  initialize: function() {
    User.on('initialized', _.bind(function() {
      this.collection = User.current.collections;
      this.listenTo(this.collection, 'add reset', this.render);
    }, this));
    this.listenTo(Dashboard.State, 'change:list-type', this.setListClass);
    this.setListClass(Dashboard.State, Dashboard.State.get('list-type'));
  }
}, require('views/toggle'), require('views/toggle_list')));

module.exports = Data;
