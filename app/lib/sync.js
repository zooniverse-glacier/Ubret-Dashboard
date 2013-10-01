var User = zooniverse.models.User;

var Sync = function(method, model, options) {
  var host;
  if (!location.port || (location.port === '3333'))
    host = "https://dev.zooniverse.org/projects/";
  else if (location.port === '3334')
    host = "http://localhost:3000/projects/";
  var baseURL = host + require('lib/state').get('project');
  options.url = _.result(model, 'url');
  if (!(options.url.match(baseURL)))
    options.url = baseURL + options.url;
  options.crossDomain = true;
  if (!_.isNull(User.current)) {
    options.beforeSend = function(xhr) {
      var auth = base64.encode(User.current.name + ":" + User.current.api_key);
      xhr.setRequestHeader('Authorization', "Basic: " + auth);
    };
  }
  return Backbone.sync(method, model, options);
};

module.exports = Sync;
