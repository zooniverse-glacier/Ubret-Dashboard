var User = zooniverse.models.User
  state = require('lib/state');

var Sync = function(method, model, options) {
  var baseURL = (!location.port) ? "https://zoo-data.herokuapp.com" : "http://localhost:3002";
  baseURL = baseURL + "/user/" + User.current.id + "/project/" + state.get('project');
  options.url = _.result(model, 'url');
  if (!(options.url.match(baseURL)))
    options.url = baseURL + options.url;
  options.crossDomain = true;
  return Backbone.sync(method, model, options);
};

module.exports = Sync;
