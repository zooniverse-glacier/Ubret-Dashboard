var Menu = Backbone.View.extend({
  toggle: function() {
    this.$el.toggleClass('active');
  }
});

module.exports = Menu;
