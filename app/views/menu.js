Menu = Backbone.View.extend({
  el: '#global-menu',

  events: {
    'click li' : 'navigateTo'
  },

  pages: {
    'saved' : '#saved-dashboards',
    'dashboard' : '#current-dashboard',
    'data' : '#saved-data'
  },

  initialize: function() {
    this.menuItems = this.$('a');
    this.listenTo(this.model, 'change:project', this.updateProject);
    this.listenTo(this.model, 'change:page', this.updateActive);
    this.listenTo(this.model, 'change:currentDashboard', this.updateDashboard);
  },

  updateDashboard: function(state, dashboard) {
    if (!dashboard) {
      this.$('#copy-dashboard, #current-dashboard').addClass('disabled');
      return;
    }
    this.$('#copy-dashboard, #current-dashboard').removeClass('disabled');
  },

  updateActive: function(state, page) {
    if (this.active)
      this.active.removeClass('active');
    this.active = this.$(this.pages[page]);
    this.active.addClass('active');
  },

  navigateTo: function(ev) {
    var navigate = _.bind(function(destination) {
      Dashboard.router.navigate('#/' + this.model.get('project') + destination, { trigger: true })
    }, this);

    ev = $(ev.target);

    if (ev.hasClass('disabled'))
      return;
    else if (ev.attr('id') === 'saved-dashboards')
      navigate('/dashboards');
    else if (ev.attr('id') === 'saved-data')
      navigate('/data');
    else if (ev.attr('id') === 'current-dashboard')
      navigate('/dashboards/' + this.model.get('currentDashboard').id);
    else if (ev.attr('id') === 'new-dashboard')
      navigate('/dashboards/new');
    else if (ev.attr('id') === 'copy-dashboard')
      this.model.get('currentDashboard').copy().then(function(response) {
        navigate('/dashboards/' + response)
      });

    $('#menu').toggleClass('active');
    this.toggle();
  },

  toggle: function() {
    this.$el.toggleClass('active');
  }
});

module.exports = Menu;
