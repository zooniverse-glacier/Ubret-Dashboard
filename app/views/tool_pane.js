var ToolPane = Backbone.View.extend({
  render: function() {
    this.el = this.model.getUbretTool().el;
    return this;
  },
});

module.exports = ToolPane;
