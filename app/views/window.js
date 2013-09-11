var state = require('lib/state'),
  ToolPane = require('views/tool_pane'),
  SettingsPane = require('views/settings_pane'),
  TitleBar = require('views/title_bar');

var Window = Backbone.View.extend({
  template: require('templates/window'),
  className: 'container',

  events: {
    'dragenter' : 'handleWindowDrag',
    'dragover' : 'handleWindowDrag',
    'dragover .add-to-chain' : 'handleAddToChain',
    'dragover .add-new-chain' : 'handleNewChain',
    'dragleave .add-to-chain' : 'handleAddToChain',
    'dragleave .add-new-chain' : 'handleNewChain',
    'drop .add-to-chain' : 'dropAdd',
    'drop .add-new-chain' : 'dropNew'
  },

  initialize: function(options) {
    if (options.dashboard) {
      this.dashboard = options.dashboard;
      this.listenTo(this.dashboard, 'change:zoom', this.render);
    }

    this.titleBar = new TitleBar({model: this.model});
    this.toolPane = new ToolPane({model: this.model});
    this.settingsPane = new SettingsPane({model: this.model});

    this.listenTo(this.titleBar, 'close', this.close);
  },

  close: function() {
    this.model.destroy();
    this.remove();
  },

  handleWindowDrag: function(ev) {
    this.$('.drag-target').show();
    return false;
  },

  handleAddToChain: function(ev) {
    return false;
  },

  handleNewChain: function(ev) {
    return false;
  },

  dropAdd: function(ev) {
    ev = ev.originalEvent;
    ev.preventDefault();
    this.$('.drag-target').show();

    var tool = JSON.parse(ev.dataTransfer.getData('application/json'));
    this.model.createChild(tool);
  },

  dropNew: function(ev) {
    ev = ev.originalEvent;
    ev.preventDefault();
    this.$('.drag-target').show();
  },

  render: function() {
    this.$el.html(this.template());
    this.$('.title-bar').html(this.titleBar.render().el);
    if (!this.dashboard || this.dashboard.get('zoom') === 1) {
      this.$('.tool-pane').html("<h2>" + this.model.get('name') + "</h2>");
    } else {
      this.$('.tool-pane').html(this.toolPane.render().el);
      this.$('.settings-pane').html(this.settingsPane.render().el);
    }
    return this;
  }
});

module.exports = Window;
