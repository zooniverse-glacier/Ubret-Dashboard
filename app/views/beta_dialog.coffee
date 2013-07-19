Dialog = require 'views/dialog'

class BetaDialog extends Dialog
  user: require 'lib/user'
  title: "ZooTools Beta"
  confirmation: "Don't Show Again"

  template: """<p>ZooTools is a Beta project, bugs may occur! Please report any problems you have to <a href="mailto:support@zooniverse.org">Support@Zooniverse</a>. Thank you for using ZooTools!</p>"""

  confirmCallback: (e) => @user.current.dismissBeta()

  initialize: ->
    super
    
  render: =>
    super
    @content @template
    @

module.exports = BetaDialog

