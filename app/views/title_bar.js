var TitleBar = Backbone.View.extend({
  template: require("templates/title_bar"),

  initialize: function() {
    this.listenTo(this.model, "change:name", this.setName);
  },

  events: {
    "click .close" : "triggerClose"
  },

  triggerClose: function() {
    this.trigger('close');
  },

  setName: function(m, title) {
    this.$('.title').text(title);
  },

  render: function() {
    this.$el.html(this.template(this.model));
    return this;
  }
});

module.exports = TitleBar;
