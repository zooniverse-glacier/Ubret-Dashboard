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
    this.listenTo(this, 'add:tools remove:tools change:tools[*].data', this.groupRows);
    this.groupRows();

    if (_.isString(this.url)) {
      if (_.last(this.url.split('/')) == 'dashboards')
        this.url = this.url + '/' + this.id;
    }
  },

  defaults: {
    zoom: 3,
    rows: [],
    tools: []
  },

  sync: require('lib/sync'),

  urlRoot: "/dashboards",

  url: function() {
    return "/dashboards/" + this.id;
  },

  destroy: function() {
    delete this.url;
    Backbone.AssociatedModel.prototype.destroy.call(this);
  },

  groupRows: function() {
    var rows = this.get('rows'),
      chains = this.get('tools').getChains(),
      removedRows = _.without.apply(null, [rows.pluck('id')].concat(_.map(chains, function(c) { return c.get('row') })));
   
    rows.remove(removedRows) 

    _.each(chains, function(chain) {
      row = chain.get('row');
      tools = this.get('tools').toolTree(chain);
      if (rows.get(row)) {
        rows.get(row).set('models', tools);
        rows.get(row).set('length', tools.length);
      } else {
        rows.add({ id: row, models: tools, index: 0, length: tools.length });
      }
    }, this);
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
    var url = (!location.port || (location.port === "3333")) ? 
      "https://dev.zooniverse.org/projects/" : "http://localhost:3000/projects/";
    url = url + this.state.get('project') + "/dashboards/" +  this.id + "/fork";
    console.log(url);
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
