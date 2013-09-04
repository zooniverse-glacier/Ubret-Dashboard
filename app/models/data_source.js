DataSource = Backbone.AssociatedModel.extend({
  sync: Dashboard.Sync,

  isInternal: function() {
    return this.get('source_type') === 'internal';
  },

  isExternal: function() {
    return !this.isInternal();  
  }
});

module.exports = DataSource;
