UserDashboards = Dashboard.ProjectBasedCollection.extend({
  model: Dashboard.Dashboard, 

  url: "/dashboards"
});

module.exports = UserDashboards;
