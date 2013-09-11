var state = require('lib/state'),
  ToolPane = require('views/tool_pane'),
  SettingsPane = require('views/settings_pane'),
  TitleBar = require('views/title_bar');

var Window = Backbone.View.extend({
  template: require('templates/window'),

  initialize: function() {
    this.model.getUbretTool();
    this.titleBar = new TitleBar({model: this.model});
    this.toolPane = new ToolPane({model: this.model});
    this.settingsPane = new SettingsPane({model: this.model});
    this.listenTo(this.model, 'height width', this.setSize);
    this.listenTo(this.model, 'top left', this.setPosition);
    this.listenTo(this.titleBar, 'close', this.close);
  },

  close: function() {
    this.model.destroy();
    this.remove();
  },

  render: function() {
    this.$el.html(this.template());
    this.$('.title-bar').html(this.titleBar.render().el);
    this.$('.tool-pane').html(this.toolPane.render().el);
    this.$('.settings-pane').html(this.settingsPane.render().el);
    return this;
  }
});

module.exports = Window;
