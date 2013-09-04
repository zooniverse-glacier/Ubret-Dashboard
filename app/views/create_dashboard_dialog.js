var CreateDashboard = require('views/create_dashboard')

module.exports = new zooniverse.controllers.Dialog({
  content: new CreateDashboard().$el
});
