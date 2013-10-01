var DashboardChildren = Backbone.Collection.extend({
  model: require('models/dashboard'),

  url: function() {
    return "/dashboards/" + this.id + "/children";
  },

  sync: require('lib/sync')
});

module.exports = DashboardChildren;
