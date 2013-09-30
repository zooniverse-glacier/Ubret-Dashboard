var User = zooniverse.models.User,
  Window = require('views/window'),
  State = require('lib/state');

var Dashboard = Backbone.View.extend(_.extend({
  el: '#dashboard',
  windowMinHeight: 100,
  windowPadding: 42,
  windowMargin: 40,
  rowTemplate: require('templates/row'),

  initialize: function() {
    User.on('initialized', _.bind(function() {
      this.collection = User.current.dashboards;
    }, this));
    State.on('change:currentDashboardId', this.updateDashboard, this);
    State.on('change:page', this.reset, this);
  },

  events: {
    'click #zoom-in' : 'zoomIn',
    'click #zoom-out' : 'zoomOut',
    'click #examine' : 'examineMode',
    'click .new-tool-chain' : 'startToolChain',
    'mouseover .scroll' : 'showScroll',
    'mouseleave .scroll' : 'hideScroll',
    'click .scroll' : 'scrollRow'
  },

  examineMode: function() {
    var selected = this.model.get("tools").chain()
      .filter(function(m) { return m.get('selected') })
      .pluck('id').value().join(',');
    if (selected === '')
      return;
    var url = location.hash + "/examine/" + selected;
    window.router.navigate(url, {trigger: true});
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
      position = tools.nextRow();

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
      .attr('id', function(d) { return "row-" + d.id })
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
      }, this))
      .append(_.bind(this.drawWindow, this));

    tools.style('height', height + 'px')
      .style('width', width + 'px')
      .transition()
      .style('left', _.bind(this.windowSpacing, this))

    tools.exit().style('z-index', -10)
      .transition().style('left', _.bind(function(d, i) {
        if (rs && rs.previous('index') < rs.get('index'))
          return this.windowSpacing(0, -1)
        else if (rs)
          return this.windowSpacing(0, itemsInRow + 1)
      }, this)).remove();

    this.setZoom(zoomLevel);
    return this;
  },

  drawWindow: function(t) { 
    var window = new Window({model: t, dashboard: this.model});
    return window.render().el; 
  },

  reset: function(s, p) {
    if (p !== 'dashboard')
      return;
    this.$('.row').remove()
    this.render();
  },

  setZoom: function(zoom) {
    var height = this.windowMinHeight * zoom,
      width = Math.floor(height * (3/2));

    this.model.get('tools').setSize(height, width)
    this.$('.btn').removeClass('disabled');

    if (zoom === 1)
      this.$('#zoom-out').addClass('disabled');
    else if (zoom === 8)
      this.$('#zoom-in').addClass('disabled');
  },

  updateDashboard: function(state) {
    model = state.get('currentDashboard');
    this.stopListening();
    this.model = model;
    this.listenTo(this.model, 'change:zoom', this.render);
    this.listenTo(this.model, 'change:rows[*] add:rows remove:rows', this.render);
    if (this.model.get('rows'))
      this.render();
  }
}, require('views/toggle')));

module.exports = Dashboard;
