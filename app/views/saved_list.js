var User = zooniverse.models.User;

var Saved = Backbone.View.extend(_.extend({
    el: "#saved",
    state: require('lib/state'),

    template: require('templates/saved_list'), 

    initialize: function() {
      User.on('initialized', _.bind(function() {
        this.collection = User.current.dashboards; 
        this.listenTo(this.collection, 'add reset remove', this.render);
      }, this));
      this.listenTo(this.state, 'change:list-type', this.setListClass);
      this.setListClass(this.state, this.state.get('list-type'));
    },

    events: {
      'click .layouts button' : 'setListType',
      'click .delete' : 'removeDashboard'
    },

    removeDashboard: function(ev) {
      var model = this.collection.get(ev.target.dataset.id);
      model.destroy();
    }

  }, require('views/toggle'), require('views/toggle_list')));

module.exports = Saved;
