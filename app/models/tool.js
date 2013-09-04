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

  getChildren: function() {
    if (!this.collection)
      return;
    return this.collection.filter(function(t) {
      return t.get('data_source.source_id') === this.id
    }, this);
  }
});

module.exports = Tool;
