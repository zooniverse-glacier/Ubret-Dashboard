Spine = require 'spine'

class Tool extends Spine.Model
  @configure 'Tool', 'name', 'desc', 'window', 'settings'



module.exports = Tool