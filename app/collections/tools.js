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

  getChains: function() {
    return this.filter(function(t) {
      return t.get('tool_type') === 'tool_chain';
    });
  },

  setHeight: function(height) {
    this.each(function(m) { m.getUbretTool().setHeight(height); });
  },

  toolTree: function(tool, accum) {
    if (!accum)
      accum = [];

    child = tool.getNonChainChild();
    if (child)
      return this.toolTree(child, accum.concat(tool));
    else
      return accum.concat(tool);
  },

  nextRow: function () {
    if (this.isEmpty())
      return 0
    else
      return this.max(function(t) { return t.get('row') }).get('row') + 1;
  }
});

module.exports = Tools;
