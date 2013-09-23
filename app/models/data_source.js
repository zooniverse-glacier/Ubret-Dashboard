var DataSource = Backbone.AssociatedModel.extend({
  sync: require('lib/sync'),

  isInternal: function() {
    return !!this.get('parent'); 
  },

  isExternal: function() {
    return !this.isInternal();  
  }
});

module.exports = DataSource;
