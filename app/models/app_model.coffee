class AppModel extends Backbone.Model

  triggerEvent: (event) ->
    @trigger event
    Backbone.Mediator.publish event

module.exports = AppModel