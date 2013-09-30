var Examine = require('views/examine');

module.exports = new zooniverse.controllers.Dialog({
  content: new Examine().$el
});
