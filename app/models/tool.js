Tool = Backbone.AssociatedModel.extend({
  idAttribute: "_id",

  relations: [
    {
      type: Backbone.One,
      key: 'data_source',
      relatedModel: require('models/data_source')
    }
  ],

  sync: require('lib/sync'), 

  createUbretTool: function() {
    if (this.get('tool_type'))
      return;
    this.ubretTool = require('tools/' + this.get('tool_type'));
    this.ubretTool = new this.ubretTool(this.get("settings"), this.getParent());
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
