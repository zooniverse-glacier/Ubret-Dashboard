var SettingsPane = Backbone.View.extend({
  render: function() {
    _.each(this.model.getUbretTool().settingViews, function(sv) {
      this.$el.append(sv.el);
    }, this);
    return this;
  }
});

module.exports = SettingsPane;
