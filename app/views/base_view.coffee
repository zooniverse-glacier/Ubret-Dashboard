
class BaseView extends Backbone.View
  _.extend @prototype, Backbone.Events

  view_opts: {}

  assign: (selector, view) =>
    if _.isObject(selector)
      selectors = selector
    else
      selectors = {}
      selectors[selector] = view
    
    unless selectors then return

    _.each selectors, (view, selector) =>
      view.setElement(@$(selector)).render()


module.exports = BaseView