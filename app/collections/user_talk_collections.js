var ProjectBasedCollection = require('collections/project_based_collection');

var UserTalkCollections = ProjectBasedCollection.extend({
  url: function() {
    return "/talk/users/" + User.current.id + "?type=my_collections";
  },

  parse: function(response) {
    return _.map(response.my_collections, function(col) {
      return {
        id: col.zooniverse_id,
        image: col.subjects[0].location.standard,
        title: col.title,
        subjects: _.pluck(col.subjects, 'zooniverse_id'),
        thumbnail: col.subjects[0].location.thumbnail,
        description: col.description
      };
    });
  }
});

module.exports = UserTalkCollections;
