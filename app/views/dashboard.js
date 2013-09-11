var User = zooniverse.models.User,
  Window = require('views/window');

var Dashboard = Backbone.View.extend(_.extend({
  el: '#dashboard',
  state: require('lib/state'),
  newToolChainTemplate: require('templates/new_tool_chain'),
  windowMinHeight: 100,

  initialize: function() {
    User.on('initialized', _.bind(function() {
      this.collection = User.current.dashboards;
    }, this));
    this.listenTo(this.state, 'change:currentDashboard', this.updateDashboard);
  },

  events: {
    'click #zoom-in' : 'zoomIn',
    'click #zoom-out' : 'zoomOut',
    'click .new-tool-chain' : 'startToolChain'
  },

  zoomIn: function(ev) {
    if ($(ev.target).hasClass('disabled'))
      return;
    var curZoom = this.model.get('zoom') + 1;
    this.model.set('zoom', curZoom);
  },

  zoomOut: function(ev) {
    if ($(ev.target).hasClass('disabled'))
      return;
    var curZoom = this.model.get('zoom') - 1;
    this.model.set('zoom', curZoom);
  },

  startToolChain: function(ev) {
    var tools = this.model.get('tools'),
      position = (tools.isEmpty()) ? 0 : tools.max(function(t) { return t.get('top') }) + 1;
    this.model.get('tools').create({
      tool_type: 'tool_chain',
      name: "New Tool Chain",
      row: position
    });
  },

  render: function() {
    if (!this.model)
      return;

    var zoomLevel = this.model.get('zoom'),
      height = this.windowMinHeight * zoomLevel,
      width = Math.floor(height * (3/2));


    var chains = _.pairs(this.model.get('tools')
        .groupBy(function(t) { return t.get('row'); }));

    rows = d3.select(this.el).selectAll('.row')
      .data(chains, function(d) { return d[0] + d[1][0].id; });

    rows.enter().append('div')
      .attr('class', 'row');

    rows.exit().remove();

    var tools = rows.selectAll('.window')
      .data(function(d) { return d[1];}, function(d) { return d.id });

    tools.enter().append('div')
      .attr('class', 'window')
      .append(_.bind(this.drawWindow, this));

    tools.style('height', height + 'px')
      .style('width', width + 'px')

    tools.exit().remove();
    this.setZoom(null, zoomLevel);
  },

  drawWindow: function(t) { 
    var window = new Window({model: t, dashboard: this.model});
    return window.render().el; 
  },

  setZoom: function(state, zoom) {
    this.model.get('tools').setHeight(this.windowMinHeight * zoom)
    this.$('.btn').removeClass('disabled');
    if (zoom === 1)
      this.$('#zoom-out').addClass('disabled');
    else if (zoom === 8)
      this.$('#zoom-in').addClass('disabled');
  },

  updateDashboard: function(state, model) {
    this.stopListening();
    this.model = model;
    this.render();
    this.listenTo(this.model, 'change:zoom', this.render);
    this.listenTo(this.model, 'change:zoom', this.setZoom);
    this.listenTo(this.model, 'remove:tools add:tools', this.render);
  }
}, require('views/toggle')));

module.exports = Dashboard;
