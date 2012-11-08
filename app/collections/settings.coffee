Setting = require 'models/setting'

class Settings extends Backbone.Collection
  model: Setting

module.exports = Settings