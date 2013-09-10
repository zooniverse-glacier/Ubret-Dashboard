var User = zooniverse.models.User;

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
    'click #zoom-out' : 'zoomOut'

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

  render: function() {
    this.$('.row').remove();
    if (!this.model)
      return;
    //this.model.get('tools').groupBy('top');
    this.$el.append('<div class="row"></div>')
    this.$('.row:last-child').append(this.newToolChainTemplate());
    this.setZoom();
  },

  setZoom: function(model, zoom) {
    console.log('here', zoom);
    var zoomLevel = zoom || this.model.get('zoom');
    var height = this.windowMinHeight * zoomLevel;
    var width = Math.floor(height * (3/2));
    this.$('.window').height( height + "px" )
      .width( width + "px");
    this.$('.btn').removeClass('disabled');
    if (zoomLevel === 1)
      this.$('#zoom-out').addClass('disabled');
    else if (zoomLevel === 8)
      this.$('#zoom-in').addClass('disabled');
  },

  updateDashboard: function(state, model) {
    this.stopListening();
    this.model = model;
    this.render();
    console.log('here')
    this.listenTo(this.model, 'change:zoom', this.setZoom);
  }
}, require('views/toggle')));

module.exports = Dashboard;
