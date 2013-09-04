Create = Backbone.View.extend({
  className: 'create-dashboard',
  template: _.template($("#new-dashboard").html()),

  initialize: function() {
    this.listenTo(Dashboard.State, 'change:project', this.setSelected);
    User.on('initialized', _.bind(function() {
      this.collection = User.current.collections;
      this.listenTo(this.collection, 'add reset', this.render);
      this.render();
    }, this));
  },

  events: {
    'click .create-dashboard-go' : 'createDashboard'
  },

  setSelected: function() {
    this.$('.create-dashboard-project').val(Dashboard.State.get('project'));
  },

  createDashboard: function(ev) {
    this.$el.addClass('loading');
    var newDashboard = User.current.dashboards.create({
      name: this.$('.create-dashboard-name').val(), 
      project: this.$('.create-dashboard-project').val()
    }, {wait: true})
    newDashboard.once('sync', _.bind(function(m) {
      this.$el.removeClass('loading');
      var url = "#/" + m.get('project') + "/dashboards/" + m.id;
      Dashboard.router.navigate(url, {trigger: true});
    }, this));
  },

  render: function() {
    this.$el.html(this.template({project: Dashboard.State.get('project')}));
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

module.exports = Create;
