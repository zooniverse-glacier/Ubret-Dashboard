Tool = Backbone.AssociatedModel.extend({
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

module.exports = Tool;
