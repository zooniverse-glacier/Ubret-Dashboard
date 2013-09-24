var state = require('lib/state'),
  ToolPane = require('views/tool_pane'),
  SettingsPane = require('views/settings_pane'),
  TitleBar = require('views/title_bar');

var Window = Backbone.View.extend({
  template: require('templates/window'),
  className: 'container',

  events: {
    'dragover' : 'showTargets',
    'dragleave' : 'hideTargets',
    'dragover .add-to-chain' : 'handleAddToChain',
    'dragover .add-new-chain' : 'handleNewChain',
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
    this.listenTo(this.model, 'change:settings_active', this.toggleSettings)
  },

  close: function() {
    this.model.destroy();
    this.remove();
  },

  showTargets: function(ev) {
    this.$('.drag-target').show();
  },

  hideTargets: function(ev) {
    this.$('.drag-target').hide();
  },

  handleAddToChain: function(ev) {
    this.$('.drag-target').show();
    return false;
  },

  handleNewChain: function(ev) {
    this.$('.drag-target').show();
    return false;
  },

  toggleSettings: function(m, sa) {
    if (sa)
      this.$('.settings-pane').addClass('active');
    else
      this.$('.settings-pane').removeClass('active');
  },

  dropAdd: function(ev) {
    ev = ev.originalEvent;
    ev.preventDefault();
    this.$('.drag-target').hide();
    var tool = JSON.parse(ev.dataTransfer.getData('application/json'));
    this.model.createChild(tool);
  },

  dropNew: function(ev) {
    ev = ev.originalEvent;
    ev.preventDefault();
    this.$('.drag-target').hide();
    var newTool = JSON.parse(ev.dataTransfer.getData('application/json'));
    this.model.collection.create({
      tool_type: 'tool_chain',
      name: "New Chain from " + this.model.get('name'),
      row: this.model.collection.nextRow(),
      data: {
        parent: this.model.id
      }
    }, {wait: true});

    this.model.collection.once('add', function(tool) {
      tool.createChild(newTool)
    });
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

    if (this.model.get('settings_active'))
      this.$('.settings-pane').addClass('active') 

    this.titleBar.delegateEvents();
    this.toolPane.delegateEvents();
    this.settingsPane.delegateEvents();
    return this;
  }
});

module.exports = Window;
