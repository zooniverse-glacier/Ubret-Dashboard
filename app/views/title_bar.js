var TitleBar = Backbone.View.extend({
  template: require("templates/title_bar"),

  initialize: function() {
    this.listenTo(this.model, "change:name", this.setName);
  },

  events: {
    "click" : "selectTool",
    "dblclick .title" : "editTitle",
    "keypress .title" : "finishEdit",
    "click .close" : "triggerClose",
    "click .settings-toggle" : "toggleSettings"
  },

  triggerClose: function() {
    this.trigger('close');
  },

  selectTool: function() {
    this.model.set("selected", true);
  },

  setName: function(m, title) {
    this.$('.title input').hide();
    this.$('.title h4').text(title).show();
  },

  editTitle: function() {
    this.$('.title input').show().focus().select()
    this.$('.title h4').hide()
  },

  finishEdit: function(ev) {
    if (ev.key === "Enter") {
      this.model.update('name', this.$('.title input').val())
    }
  },

  toggleSettings: function() {
    var sa = (this.model.get('settings_active') || false);
    this.$('.settings-toggle').toggleClass('active');
    this.model.update('settings_active', !sa);
  },

  render: function() {
    this.$el.html(this.template(this.model));
    return this;
  }
});

module.exports = TitleBar;
