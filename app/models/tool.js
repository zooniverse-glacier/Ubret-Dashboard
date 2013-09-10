var ToolConfig = require('config/tool'),
  User = zooniverse.models.User;

var Tool = Backbone.AssociatedModel.extend({
  idAttribute: "_id",

  relations: [
    {
      type: Backbone.One,
      key: 'data_source',
      relatedModel: require('models/data_source')
    }
  ],

  defaults: {
    settings: {}
  },

  initialize: function() {
    if (!this.get('tool_type'))
      throw new Error("Tool must have a type defined");
    
    this.setDefaults();
    this.setTool();

    if (this.get('tool_type') === "tool_chain") {
      User.on("initialized", _.bind(this.setCollections, this));
      if (User.current)
        this.setCollections();
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
    _.each(ToolConfig[this.get("tool_type")], function(v, k) {
      if (!settings[k])
        if (_.isFunction(v) && (k !== "User"))
          settings[k] = v();
        else
          settings[k] = v;
    });
    this.set('settings', settings);
  },

  setTool: function() {
    this.UbretTool = require('tools/' + this.get('tool_type')); 
  },

  sync: require('lib/sync'), 

  getUbretTool: function() {
    if (!this.ubretTool) 
      this.ubretTool = new this.UbretTool(this.get('settings'), 
                                          this.getParent());
    return this.ubretTool
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
  }
});

module.exports = Tool;
