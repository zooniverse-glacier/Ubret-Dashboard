AppView = require 'views/app_view'

InputView = require 'views/params/input'
RangeView = require 'views/params/range'
EmptyView = require 'views/params/empty'

class Params extends AppView

  render: =>
    @views = []
    @collection.each (param) =>
      switch param.get('type')
        when 'Input' then paramView = new InputView({model: param})
        when 'Range' then paramView = new RangeView({model: param})
        else
          paramView = new EmptyView({model: param}) # Sort of temporary

      @views.push paramView
      @$el.append paramView.render().el
    @

  setState: =>
    _.each @views, (view) ->
      view.setState()

module.exports = Params