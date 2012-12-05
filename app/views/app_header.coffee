BaseView = require 'views/base_view'
Manager = require 'modules/manager'

class AppHeader extends BaseView
  template: require './templates/layout/header'

  render: =>
    @$el.html @template()
    @
    
module.exports = AppHeader