var IndexView = require('views/index')

module.exports = new zooniverse.controllers.Dialog({
  content: new IndexView().$el
});
