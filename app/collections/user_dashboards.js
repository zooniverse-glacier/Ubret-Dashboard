var ProjectBasedCollection = require('collections/project_based_collection');

var UserDashboards = ProjectBasedCollection.extend({
  model: require('models/dashboard'),

  url: "/dashboards"
});

module.exports = UserDashboards;
