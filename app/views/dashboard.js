var User = zooniverse.models.User,
  Window = require('views/window');

var Dashboard = Backbone.View.extend(_.extend({
  el: '#dashboard',
  state: require('lib/state'),
  windowMinHeight: 100,
  windowPadding: 42,
  windowMargin: 40,
  rowTemplate: require('templates/row'),

  initialize: function() {
    User.on('initialized', _.bind(function() {
      this.collection = User.current.dashboards;
    }, this));
    this.listenTo(this.state, 'change:currentDashboard', this.updateDashboard);
  },

  events: {
    'click #zoom-in' : 'zoomIn',
    'click #zoom-out' : 'zoomOut',
    'click .new-tool-chain' : 'startToolChain',
    'mouseover .scroll' : 'showScroll',
    'mouseleave .scroll' : 'hideScroll',
    'click .scroll' : 'scrollRow'
  },

  showScroll: function(ev) {
    this.$(ev.target).addClass('active');
  },

  hideScroll: function(ev) {
    this.$(ev.target).removeClass('active');
  },

  scrollRow: function(ev) {
    var target = this.$(ev.target),
      row = target.data('row'),
      oldIndex = this.model.get('rows[' + row + '].index'),
      direction = (target.hasClass('pull-left')) ? -1 : 1;

    if (oldIndex === this.model.get('row[0].length') - 1 && direction === -1)
      return;
    else if (oldIndex === 0 && direction === 1)
      return;
    else
      this.model.get('rows[' + row + ']')
        .set('index', (oldIndex - direction));
  },

  windowSpacing: function(_, i) {
    var zoom = this.model.get('zoom'),
      spacing = this.windowMinHeight * 1.5 * zoom 
        + this.windowPadding + this.windowMargin;
    return i * spacing + 'px';
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
      position = (tools.isEmpty()) ? 0 : 
        tools.max(function(t) { return t.get('row') }).get('row') + 1;

    this.model.get('tools').create({
      tool_type: 'tool_chain',
      name: "New Tool Chain",
      row: position
    });
  },

  render: function(rs) {
    if (!this.model || !this.model.get('tools'))
      return;

    var zoomLevel = this.model.get('zoom'),
      height = this.windowMinHeight * zoomLevel,
      width = Math.floor(height * (3/2));
      itemsInRow = Math.floor((window.innerWidth * 1.1) / width) + 1;

    var chains = this.model.get('rows');
    rows = d3.select(this.el).selectAll('.row')
      .data(chains.models, function(d) { return d.id });

    rows.enter().insert('div', '.new-tool-chain')
      .attr('class', 'row')
      .attr('id', function(d) { console.log(d.id); return "row-" + d.id })
      .html(_.bind(function(d) { return this.rowTemplate({id: d.id}); }, this));

    rows.style('height', height + this.windowPadding +"px");

    rows.exit().remove();

    var tools = rows.selectAll('.window').data(function(d) { 
      return d.get('models').slice(d.get('index'), d.get('index') + itemsInRow)
    }, function(d) { return d.id });

    tools.enter().append('div')
      .attr('class', 'window')
      .style('height', height + 'px')
      .style('width', width + 'px')
      .style('left', _.bind(function(_, i) {
        if (rs && rs.previous('index') > rs.get('index'))
          i = i - 1;
        else if (rs)
          i = i + 1;
        return this.windowSpacing(_, i);
      }, this)).append(_.bind(this.drawWindow, this));

    tools.transition(1000).style('height', height + 'px')
      .style('width', width + 'px')
      .style('left', _.bind(this.windowSpacing, this))

    tools.exit().style('z-index', -10)
      .transition().style('left', _.bind(function(d, i) {
        if (rs && rs.previous('index') < rs.get('index'))
          return this.windowSpacing(0, -1)
        else if (rs)
          return this.windowSpacing(0, itemsInRow + 1)
      }, this)).remove();

    this.setZoom(zoomLevel);
  },

  drawWindow: function(t) { 
    var window = new Window({model: t, dashboard: this.model});
    return window.render().el; 
  },

  setZoom: function(zoom) {
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
    this.listenTo(this.model, 'change:rows[*] add:rows remove:rows', this.render);
  }
}, require('views/toggle')));

module.exports = Dashboard;