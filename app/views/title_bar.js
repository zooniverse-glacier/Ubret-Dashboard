var TitleBar = Backbone.View.extend({
  template: require("templates/title_bar"),

  initialize: function() {
    this.listenTo(this.model, "change:name", this.setName);
  },

  events: {
    "click .close" : "triggerClose",
    "click .settings-toggle" : "toggleSettings"
  },

  triggerClose: function() {
    this.trigger('close');
  },

  setName: function(m, title) {
    this.$('.title').text(title);
  },

  toggleSettings: function() {
    var sa = (this.model.get('settings_active') || false);
    this.$('.settings-toggle').toggleClass('active');
    this.model.set('settings_active', !sa);
  },

  render: function() {
    this.$el.html(this.template(this.model));
    return this;
  }
});

module.exports = TitleBar;
