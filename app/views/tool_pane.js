var ToolPane = Backbone.View.extend({
  render: function() {
    this.$el.html(this.model.getUbretTool().el);
    this.model.getUbretTool().delegateEvents();
    return this;
  },
});

module.exports = ToolPane;
