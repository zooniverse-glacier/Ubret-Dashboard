(function() {
  "use strict";
  var Dashboard = this.Dashboard;
  var User = this.User;

  Dashboard.DataSource = Backbone.AssociatedModel.extend({
    sync: Dashboard.Sync,

    isInternal: function() {
      return this.get('source_type') === 'internal';
    },

    isExternal: function() {
      return !this.isInternal();  
    }
  });

  Dashboard.Tool = Backbone.AssociatedModel.extend({
    idAttribute: "_id",

    relations: [
      {
        type: Backbone.One,
        key: 'data_source',
        relatedModel: Dashboard.DataSource
      }
    ],

    sync: Dashboard.Sync,

    getChildren: function() {
      if (!this.collection)
        return;
      return this.collection.filter(function(t) {
        return t.get('data_source.source_id') === this.id
      }, this);
    }
  });

  Dashboard.Tools = Backbone.Collection.extend({
    model: Dashboard.Tool,

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
}).call(this);
