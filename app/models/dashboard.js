var Dashboard = Backbone.AssociatedModel.extend({
  relations: [
    {
      type: Backbone.Many,
      key: 'tools',
      relatedModel: Dashboard.Tool,
      collectionType: Dashboard.Tools
    }
  ],

  initialize: function() {
    this.listenTo(this, 'remove', function() {
      delete this.url;
      this.destroy();
    }); 
  },

  sync: Dashboard.Sync,

  urlRoot: "/dashboards",

  fetch: function() {
    if (!Dashboard.State.get('project'))
      return;
    return Dashboard.Dashboard.__super__.fetch.call(this);
  },

  getFormattedDate: function(field) {
    var date = moment(this.get(field)),
      now = moment();
    if (date.isBefore(now.subtract('days', 2)))
      return date.format('lll');
    else if (date.isBefore(now.subtract('days', 1)))
      return 'Yesterday';
    else
      return date.fromNow();
  },

  copy: function() {
    var url = "http://localhost:3000/projects/" + 
      Dashboard.State.get('project') + 
      "/dashboards/" + 
      this.id + "/fork";
    return $.ajax({
      type: 'POST',
      url: url,
      crossDomain: true,
      beforeSend: function(xhr) {
        var auth = base64.encode(User.current.name + ":" + User.current.api_key);
        xhr.setRequestHeader('Authorization', "Basic: " + auth);
      }
    }).then(function(response) {
      User.current.dashboards.add(response);
      return response.id;
    });
  }
});

module.exports = Dashboard;
