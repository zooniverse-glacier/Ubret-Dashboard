(function() {
  var Dashbaord = this.Dashboard;

  Dashboard.ToggleListLayout = {
    setListClass: function(state, type) {
      var changed = state.previous('list-type');
      if (changed) {
        this.$el.removeClass(changed);
        this.$('button[data-type="' + changed + '"]').removeClass('active');
      }
      this.$('button[data-type="' + type + '"]').addClass('active');
      this.$el.addClass(type);
    },

    setListType: function(e) {
      Dashboard.State.set('list-type', e.target.dataset.type);
    },

    render: function() {
      if (!this.collection)
        return 

      this.list = d3.select(this.el)
        .select('.list-container')
        .selectAll('.listing')
        .data(this.collection.models, function(d) { return d.id; });

      this.list.enter().append('div')
        .attr('class', 'listing')
        .html(_.bind(function(d) { return this.template(d) }, this));

      this.list.exit().remove();

      return this;
    }
  };
 
  Dashboard.Saved = Backbone.View.extend(_.extend({
    el: "#saved",

    template: _.template($('#dashboard-list-template').html()),

    initialize: function() {
      User.on('initialized', _.bind(function() {
        this.collection = User.current.dashboards; 
        this.listenTo(this.collection, 'add reset', this.render);
      }, this));
      this.listenTo(Dashboard.State, 'change:list-type', this.setListClass);
      this.setListClass(Dashboard.State, Dashboard.State.get('list-type'));
    },

    events: {
      'click .layouts button' : 'setListType',
    }
  }, Dashboard.ToggleView, Dashboard.ToggleListLayout));

  Dashboard.Data = Backbone.View.extend(_.extend({
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
  }, Dashboard.ToggleView, Dashboard.ToggleListLayout));

}).call(this);

