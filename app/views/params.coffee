BaseView = require 'views/base_view'

InputView = require 'views/params/input'
RangeView = require 'views/params/range'
SelectView = require 'views/params/select'
EmptyView = require 'views/params/empty'

class Params extends BaseView
  initialize: (@params) ->
    # Nothing.

  render: =>
    @views = []
    @params.each (param) =>
      switch param.get('type')
        when 'Input' then paramView = new InputView({model: param})
        when 'Range' then paramView = new RangeView({model: param})
        when 'Select' then paramView = new SelectView({model: param})
        else
          paramView = new EmptyView({model: param}) # Sort of temporary

      @views.push paramView
      @$el.append paramView.render().el
    @

  setState: =>
    _.each @views, (view) ->
      view.setState()

module.exports = Params