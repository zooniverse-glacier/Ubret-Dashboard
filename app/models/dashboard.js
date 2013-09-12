var Dashboard = Backbone.AssociatedModel.extend({
  state: require('lib/state'),

  relations: [
    {
      type: Backbone.Many,
      key: 'tools',
      relatedModel: require('models/tool'), 
      collectionType: require('collections/tools') 
    },
    {
      type: Backbone.Many,
      key: 'rows',
      relatedModel: Backbone.AssociatedModel,
      collectionType: Backbone.Collection
    }
  ],

  initialize: function() {
    this.listenTo(this, 'remove', function() {
      delete this.url;
      this.destroy();
    }); 

    this.listenTo(this, 'add:tools remove:tools', this.groupRows);
    this.groupRows();
  },

  defaults: {
    zoom: 3,
    rows: [],
    tools: []
  },

  sync: require('lib/sync'),

  urlRoot: "/dashboards",

  groupRows: function() {
    var rows = this.get('rows')
    this.get('tools').chain().groupBy(function(m) { return m.get('row') })
      .each(function(ts, row) {
        rows.add({ id: row, models: ts, index: 0, length: ts.length });
      });
  },

  fetch: function() {
    if (!this.state.get('project'))
      return;
    return Dashboard.__super__.fetch.call(this);
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

  toJSON: function() {
    var json = this.attributes;
    delete json.rows;
    return json;
  },

  copy: function() {
    var url = "http://localhost:3000/projects/" + 
      this.state.get('project') + 
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
