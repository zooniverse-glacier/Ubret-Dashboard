(function() {
  "use strict";
  var Dashboard = this.Dashboard;
  var User = this.User;

  Dashboard.Dashboard = Backbone.AssociatedModel.extend({
    sync: Dashboard.Sync

  });
}).call(this);
