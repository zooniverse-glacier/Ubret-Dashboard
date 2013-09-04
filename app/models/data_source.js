DataSource = Backbone.AssociatedModel.extend({
  sync: require('lib/sync'),

  isInternal: function() {
    return this.get('source_type') === 'internal';
  },

  isExternal: function() {
    return !this.isInternal();  
  }
});

module.exports = DataSource;
