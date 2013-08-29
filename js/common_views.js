(function()  {
  "use strict";
  var Dashboard = this.Dashboard;
  var User = this.User;

  Dashboard.ToggleView = {
    hide: function() {
      this.$el.hide();
    },

    show: function() {
      this.$el.show();
      this.render();
    }
  };

  Dashboard.Create = Backbone.View.extend({
    template: $("#new-dashboard").html(),

    initialize: function() {
      this.listenTo(Dashboard.State, 'change:project', this.setSelected);
      this.listenTo(this.collection, 'add reset', this.render);
    },

    events: {
      'click .create-dashboard-go' : 'createDashboard'
    },

    setSelected: function() {
      this.$('.create-dashboard-project').val(Dashboard.State.get('project'));
    },

    createDashboard: function(ev) {
      var newDashboard = User.current.dashboards.create({
        name: this.$('.create-dashboard-name').val(), 
        project: this.$('.create-dashboard-project').val()
      }, {wait: true})
      newDashboard.once('sync', function(m) {
        var url = "#/" + m.get('project') + "/dashboards/" + m.id;
        Dashboard.router.navigate(url, {trigger: true});
      });
    },

    render: function() {
      this.$el.html(this.template);
      var projects = [['', {name: 'Choose a project'}]]
        .concat(_.pairs(Dashboard.projects))

      var collections = [
        {id: '', get: function() { return "Choose data" }},
        {id: ' ', get: function() { return 'No Data Please' }}
      ].concat(this.collection.models);

      var projectOptions = d3.select(this.el)
        .select('.create-dashboard-project').selectAll('option')
        .data(projects, function(d) { return d[0]});

      var dataOptions = d3.select(this.el)
        .select('.create-dashboard-data').selectAll('option')
        .data(collections, function(d) { return d.id });

      projectOptions.enter().append('option')
        .attr('value', function(d) { return d[0] })
        .text(function(d) {return d[1].name});

      projectOptions.exit().remove();

      dataOptions.enter().append('option')
        .attr('value', function(d) { return d.id; })
        .text(function(d) { return d.get('title'); });

      dataOptions.exit().remove();

      this.setSelected();
      return this;
    }
  });

}).call(this);
