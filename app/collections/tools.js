Tools = Backbone.Collection.extend({
  model: require('models/tool'),

  url: function() {
    return "/dashboards/" + this.dashboardID + "/tools"
  },

  sync: Dashboard.Sync,

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
  }
});

module.exports = Tools;
