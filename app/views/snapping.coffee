Snapping = 
  showSnap: (x, y) ->
    if x < 0
      if y < @dashTop
        Backbone.Mediator.publish 'show-snap', 'top-left', @dashHeight
      else if y > @dashBottom
        Backbone.Mediator.publish 'show-snap', 'bottom-left', @dashHeight
      else
        Backbone.Mediator.publish 'show-snap', 'left', @dashHeight
    else if x > @dashWidth
      if y < @dashTop
        Backbone.Mediator.publish 'show-snap', 'top-right', @dashHeight
      else if y > @dashBottom
        Backbone.Mediator.publish 'show-snap', 'bottom-right', @dashHeight
      else
        Backbone.Mediator.publish 'show-snap', 'right', @dashHeight
    else if y < @dashTop or y > @dashBottom
      Backbone.Mediator.publish 'show-snap', 'full', @dashHeight
    else
      Backbone.Mediator.publish 'stop-snap'
      @snap = false
      return
    @snap = true

  snapLeft: ->
    @model.save
      top: @dashTop
      left: 0
      height: @dashHeight 
      width: @dashWidth / 2

  snapRight: ->
    @model.save
      top: @dashTop
      left: @dashWidth / 2
      height: @dashHeight
      width: @dashWidth / 2

  snapFull: ->
    @model.save
      top: @dashTop
      left: 0
      height: @dashHeight
      width: @dashWidth

  snapBottomLeft: ->
    @model.save
      top: @dashBottom - (@dashHeight / 2)
      left: 0
      height: @dashHeight / 2
      width: @dashWidth / 2
  
  snapBottomRight: ->
    @model.save
      top: @dashBottom - (@dashHeight / 2)
      left: @dashWidth / 2
      height: @dashHeight / 2
      width: @dashWidth / 2

  snapTopLeft: ->
    @model.save
      top: @dashTop
      left: 0
      height: @dashHeight / 2
      width: @dashWidth / 2

  snapTopRight: ->
    @model.save
      top: @dashTop
      left: @dashWidth / 2
      height: @dashHeight / 2
      width: @dashWidth / 2

  setSnap: (x, y) ->
    if x < 0
      if y < @dashTop
        @snapTopLeft()
      else if y > @dashBottom
        @snapBottomLeft()
      else
        @snapLeft()
    else if x > @dashWidth
      if y < @dashTop
        @snapTopRight()
      else if y > @dashBottom
        @snapBottomRight()
      else
        @snapRight()
    else if y < @dashTop or y > @dashBottom
      @snapFull()

module.exports = Snapping
