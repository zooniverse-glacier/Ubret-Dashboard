BaseView = require 'views/base_view'

InputView = require 'views/params/input'
RangeView = require 'views/params/range'
SelectView = require 'views/params/select'
EmptyView = require 'views/params/empty'
HiddenView = require 'views/params/hidden'
CheckboxView = require 'views/params/checkbox'

class Params extends BaseView
  initialize: ->
    # Nothing.

  render: =>
    @views = []
    @collection.each (param) =>
      switch param.get('type')
        when 'Input' then paramView = new InputView({model: param})
        when 'Range' then paramView = new RangeView({model: param})
        when 'Select' then paramView = new SelectView({model: param})
        when 'Hidden' then paramView = new HiddenView({model: param})
        when 'Checkbox' then paramView = new CheckboxView({model: param})
        else
          paramView = new EmptyView({model: param}) # Sort of temporary

      @views.push paramView
      @$el.append paramView.render().el
    @

  setState: =>
    _.each @views, (view) ->
      view.setState()
    return @collection

module.exports = Params