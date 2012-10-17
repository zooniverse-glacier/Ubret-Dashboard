Spine = require 'spine'
Main = require 'controllers/Main'
State = require 'controllers/state'


class DashboardStack extends Spine.Stack
  el: "body"

  controllers:
    main: Main

  routes:
    '/:state': 'main'
    '/': 'main'

module.exports = DashboardStack