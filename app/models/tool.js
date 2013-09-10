Tool = Backbone.AssociatedModel.extend({
  idAttribute: "_id",

  relations: [
    {
      type: Backbone.One,
      key: 'data_source',
      relatedModel: require('models/data_source')
    }
  ],

  initialize: function() {
    this.listenTo(this, 'change:tool_type', this.setTool);
  },

  setTool: function(_, type) {
    this.UbretTool = require('tools/' + type); 
  },

  sync: require('lib/sync'), 

  ubretTool: function() {
    if (this.ubretTool);
      return this.ubretTool
    if (this.get('tool_type'))
      return;
    this.ubretTool = new this.UbretTool(this.get("settings"), this.getParent());
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
