
class UbretView extends Backbone.View
  _.extend @prototype, Backbone.Events

  assign: (selector, view) =>
    if _.isObject(selector)
      selectors = selector
    else
      selectors = {}
      selectors[selector] = view
    
    unless selectors
      return

    _.each selectors, (view, selector) =>
      view.setElement(@$(selector)).render()

module.exports = UbretView