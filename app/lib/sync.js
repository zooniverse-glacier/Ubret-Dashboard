var User = zooniverse.models.User;

var Sync = function(method, model, options) {
  var baseURL = "http://localhost:3000/projects/" + require('lib/state').get('project');
  options.url = _.result(model, 'url');
  if (!(options.url.match(baseURL)))
    options.url = baseURL + options.url;
  options.crossDomain = true;
  if (!_.isUndefined(User.current)) {
    options.beforeSend = function(xhr) {
      var auth = base64.encode(User.current.name + ":" + User.current.api_key);
      xhr.setRequestHeader('Authorization', "Basic: " + auth);
    };
  }
  return Backbone.sync(method, model, options);
};

module.exports = Sync;
