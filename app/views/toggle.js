module.exports = {
  hide: function() {
    this.$el.hide();
  },

  show: function() {
    this.$el.show();
    this.render();
  }
};
