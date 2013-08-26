(function() {
  "use strict";
  var Dashboard = this.Dashboard;
  var User = this.User;

  Dashboard.Dashboard = Backbone.AssociatedModel.extend({
    sync: Dashboard.Sync,

    getFormattedDate: function(field) {
      var date = moment(this.get(field)),
        now = moment();
      if (date.isBefore(now.subtract('days', 2)))
        return date.format('lll');
      else if (date.isBefore(now.subtract('days', 1)))
        return 'Yesterday';
      else
        return date.fromNow();
    }
  });
}).call(this);
