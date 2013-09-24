var ProjectBasedCollection = require('collections/project_based_collection'),
  sync = require('lib/zoo_data_sync');
  User = zooniverse.models.User;

var UserZooDataCollections = ProjectBasedCollection.extend({
  sync: sync,
  url: "/collection/"
});

module.exports = UserZooDataCollections;
