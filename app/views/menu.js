var Menu = Backbone.View.extend({
  toggle: function() {
    this.$el.toggleClass('active');
    $('#app').toggleClass('menu-active');
  }
});

module.exports = Menu;
