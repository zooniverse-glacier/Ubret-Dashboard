(function() {
  var Dashbaord = this.Dashboard;

  Dashboard.IndexPage = Backbone.View.extend(_.extend({
    el: "#index", 

    template: _.template($('#welcome-overlay').html()),

    initialize: function() {
      this.projectName = this.$('.name');
      User.on('initialized', _.bind(function() {
        this.collection = User.current.dashboards;
        this.dashboardCreate = new Dashboard.Create({collection: User.current.collections});
        this.render();
        this.listenTo(this.collection, 'add reset', this.updateRecents);
      }, this));
    },

    events: {
      'change select.project' : 'setProject',
    },

    setProject: function(ev) {
      if (ev.target.value === '')
        return;
      else
        Dashboard.State.set('project', ev.target.value);
    },

    updateRecents: function() {
      var recents = d3.select(this.el).select('#welcome-recents').selectAll('li')
        .data(this.collection.models.slice(0,3), function (d) { return d.id });
     
      recents.enter().append('li')
        .append('a')
        .attr('href', function(d) { 
          return "#/" + d.get('project') + "/dashboards/" + d.id 
        })
        .html(function(d) { 
          var name = '<span class="name">' + d.get('name') + '</span>';
          var data = '<span class="date">' + d.getFormattedDate('updated_at') + '</span>'
          return name + data;
        });

      recents.exit().remove();
    },

    render: function() {
      if (!User.current)
        return;

      // Render Welcome Template
      this.$('.logged-in').html(this.template({project: Dashboard.State.get('project')}));
      this.$('#welcome-create').html(this.dashboardCreate.render().el);

      if (!_.isEmpty(User.current.dashboards))
        this.updateRecents();

      return this;
    }
  }, Dashboard.ToggleView));
}).call(this);
