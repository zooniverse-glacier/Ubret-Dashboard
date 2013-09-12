var ToolConfig = require('config/tool'),
  User = zooniverse.models.User;

var Tool = Backbone.AssociatedModel.extend({
  idAttribute: "_id",

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

    if (_.isString(this.url))
      this.url = this.url + "/tools/" + this.id;

    this.persistedState = ToolConfig[this.get('tool_type')].persistedState;
    
    this.setDefaults();
    this.setTool();

    if (this.get('tool_type') === "tool_chain") {
      User.on("initialized", _.bind(function() {
        this.setCollections();
        this.listenTo(User.current.collections, 'add remove', this.setCollections);
      }, this));
    }
  },

  setCollections: function() {
    var collections = User.current.collections.chain()
      .map(function(col) { return [col.id, col.get('title')]; })
      .object().value();
    this.getUbretTool().setTalkCollections(collections);
    this.getUbretTool().setUser(User.current.id);
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

  sync: require('lib/sync'), 

  getUbretTool: function() {
    if (!this.ubretTool)  {
      var parent = this.getParent()
      if (parent)
        parent = parent.getUbretTool()
      else 
        parent = null
      this.ubretTool = new this.UbretTool(this.get('settings').toJSON(), parent); 
      this.ubretTool.state.when([], [this.persistedState], this.test, this);
    }
                                          
    return this.ubretTool
  },

  test: function(update) {
    this.update('settings', update)
  },

  resetUbret: function() {
    delete this.ubretTool;
  },

  getParent: function() {
    var parent = this.collection.get(this.get('data.parent'));
    if (!parent)
      return null;
    return parent;
  },

  getChildren: function() {
    if (!this.collection)
      return;
    return this.collection.filter(function(t) {
      return t.get('data_source.source_id') === this.id
    }, this);
  },

  createChild: function(tool) {
    tool.data = {parent: this.id};
    this.collection.create(tool, {wait: true});
  },

  update: function(attr, value, opts) {
    opts = opts || {};
    _.defaults(opts, {patch: true})
    if (this.id) 
      this.save(attr, value, opts);
    else
      this.set(attr, value);
  }
});

module.exports = Tool;
