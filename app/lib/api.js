var host;
if (!location.port || (location.port === '3333'))
  host = "https://dev.zooniverse.org";
else if (location.port === "3334")
  host = "http://localhost:3000";

module.exports = new zooniverse.Api({
    host: host
});
