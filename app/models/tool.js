var ToolConfig = require('config/tool'),
  User = zooniverse.models.User,
  State = require('lib/state');

var Tool = Backbone.AssociatedModel.extend({
  idAttribute: "_id",

  sync: require('lib/sync'), 

  relations: [
    {
      type: Backbone.One,
      key: 'data',
      relatedModel: require('models/data_source')
    },
    { 
      type: Backbone.One,
      key: 'settings',
      relatedModel: require('models/settings') 
    }
  ],

  defaults: {
    settings: {},
    data: {}
  },

  initialize: function() {
    if (!this.get('tool_type'))
      throw new Error("Tool must have a type defined");

    this.persistedState = ToolConfig[this.get('tool_type')].persistedState;
    
    this.setDefaults();
    this.setTool();

    if (this.get('tool_type') === "tool_chain") {
      if (User.current)
        this.setCollections();
      else
        User.on("initialized", _.bind(function() {this.setCollections(); }, this));
    }
  },

  setCollections: function () {
    if (!this.isActive())
      return;
    this.setTalk();
    this.setZooData();
    this.listenTo(User.current.collections, 'add remove', this.setTalk);
    this.listenTo(User.current.zooData, 'add remove', this.setZooData);
    this.getUbretTool().setUser(User.current.id);
  },

  setTalk: function() {
    var collections = User.current.collections.map(function(col) { 
      return [col.id, col.get('title')]; 
    });
    this.getUbretTool().setTalkCollections(_.object(collections));
  },

  setZooData: function() {
    var collections = User.current.zooData.map(function(col) { 
      return [col.id, {name: col.get('name'), user: col.get('user')}]; 
    });
    this.getUbretTool().setZooDataCollections(_.object(collections));
  },

  setDefaults: function() {
    var settings = this.get('settings');
    _.each(ToolConfig[this.get("tool_type")].settings, function(v, k) {
      if (!settings.get(k)) {
        if (_.isFunction(v))
          settings.set(k, v());
        else
          settings.set(k, v);
      }
    });
  },

  setTool: function() {
    this.UbretTool = require('tools/' + this.get('tool_type')); 
  },

  getUbretTool: function() {
    if (!this.ubretTool)  {
      var parent = this.getParent(),
        settings = this.get('settings').toJSON();
      if (parent)
        parent = parent.getUbretTool()
      else 
        parent = null

      this.ubretTool = new this.UbretTool(settings, parent); 
      this.ubretTool.state.when([], [this.persistedState], this.toSettings, this);
    }
    return this.ubretTool
  },

  toSettings: function(update) {
    this.update('settings', update)
  },

  resetUbret: function() {
    delete this.ubretTool;
  },

  getParent: function() {
    var parent = this.collection.get(this.get('data.parent_id'));
    if (!parent)
      return null;
    return parent;
  },

  getChildren: function() {
    if (!this.collection)
      return;
    return this.collection.filter(function(t) {
      return t.get('data.parent_id') === this.id
    }, this);
  },

  getNonChainChild: function() {
    return _.find(this.getChildren(), function(c) {
      return (c.get('tool_type') !== 'tool_chain');
    });
  },

  wipeTool: function() {
    delete this.ubretTool;
    _.each(this.getChildren(), function(c) { c.wipeTool() });
  },

  createChild: function(tool) {
    tool.data = {parent_id: this.id};
    tool.row = this.get('row');

    var child = this.getNonChainChild();
    if (child)
      this.collection.once('add', function(tool) {
        child.wipeTool();
        child.update('data', {parent_id: tool.id});
      }, this);

    this.collection.create(tool, {wait: true});
  },

  update: function(attr, value, opts) {
    if (_.isString(this.url)) {
      var lastPath = _.last(this.url.split('/'));
      if (lastPath === this.id)
        this.url = this.url
      else if (lastPath === 'dashboards') 
        this.url = this.collection.parents[0].url + "/tools/" + this.id;
      else
        this.url = this.url + "/tools/" + this.id;
    }
    
    opts = opts || {};
    _.defaults(opts, {patch: true})
    if (this.id) 
      return this.save(attr, value, opts);
    else
      return this.set(attr, value);
  },

  destroy: function() {
    var children = this.getChildren();
    var parent = this.getParent()
    if (!_.isEmpty(children)) {
      if (parent)
        _.each(children, function(c) { c.update('data', {parent_id: parent.id}); });
      else
        _.each(children, function(c) { 
          c.update('data', {parent_id: null}); 
          c.destroy()
        });
    } 
    Backbone.AssociatedModel.prototype.destroy.call(this);
  },

  isActive: function() {
    if (!this.collection.parents)
      return;
    var dashboardId = this.collection.parents[0].id;
    return State.get('currentDashboardId') === dashboardId;
  },
});

module.exports = Tool;
