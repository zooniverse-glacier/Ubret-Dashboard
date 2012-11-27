AppView = require 'views/app_view'
ParamView = require 'views/param'

class Params extends AppView

  render: =>
    @views = []
    @collection.each (param) =>
      paramView = new ParamView({model: param})
      @views.push paramView
      @$el.append paramView.render().el
    @

  setState: =>
    _.each @views, (view) ->
      view.setState()

module.exports = Params