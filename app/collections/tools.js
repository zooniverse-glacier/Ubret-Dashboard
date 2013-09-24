Tools = Backbone.Collection.extend({
  model: require('models/tool'),

  url: function() {
    return "/dashboards/" + this.parents[0].id + "/tools"
  },

  sync: require('lib/sync'), 

  getExternal: function() {
    return this.filter(function(t) { 
      return t.get('data_source').isExternal();
    });
  },

  getInternal: function() {
    return this.filter(function(t) {
      return t.get('data_source').isInternal();
    });
  },

  setHeight: function(height) {
    this.each(function(m) { m.getUbretTool().setHeight(height); });
  },

  toTree: function(startingTools) {
    if (!startingTools)
      startingTools = this.getExternal();
    return _.map(startingTools, function(t) {
      var toolTree = t.pick('_id', 'name')
      var children = t.getChildren() 
      if (!children || _.isEmpty(children)) {
        return toolTree;
      } else {
        toolTree.children = this.toTree(children);
        return toolTree;
      }
    }, this);
  },

  nextRow: function () {
    if (this.isEmpty())
      return 0
    else
      return this.max(function(t) { return t.get('row') }).get('row') + 1;
  }
});

module.exports = Tools;
