Saved = Backbone.View.extend(_.extend({
    el: "#saved",

    template: _.template($('#dashboard-list-template').html()),

    initialize: function() {
      User.on('initialized', _.bind(function() {
        this.collection = User.current.dashboards; 
        this.listenTo(this.collection, 'add reset remove', this.render);
      }, this));
      this.listenTo(Dashboard.State, 'change:list-type', this.setListClass);
      this.setListClass(Dashboard.State, Dashboard.State.get('list-type'));
    },

    events: {
      'click .layouts button' : 'setListType',
      'click .delete' : 'removeDashboard'
    },

    removeDashboard: function(ev) {
      var model = this.collection.get(ev.target.dataset.id);
      this.collection.remove(model);
    }

  }, require('views/toggle'), require('view/toggle_list')));

module.exports = Saved;
