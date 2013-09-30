var DataSource = Backbone.AssociatedModel.extend({
  sync: require('lib/sync'),

  isInternal: function() {
    return !!this.get('parent_id'); 
  },

  isExternal: function() {
    return !this.isInternal();  
  }
});

module.exports = DataSource;
