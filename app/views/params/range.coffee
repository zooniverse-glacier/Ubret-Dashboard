Param = require 'views/param'

class Range extends Param
  template: require 'views/templates/params/range'

  events:
    'mousedown .track': 'onUserStartDrag'

  render: =>
    super
    @span = @$el.find('span')
    @value = @$el.find('.value')
    @value.html @getCurrentValue().toFixed(2)
    @

  onUserStartDrag: (e) =>
    $('body').addClass 'unselectable'
    @dragging = true

    # Set bounds
    borderLeft = @$el.offset().left + (@span.width() / 2)
    borderRight = @$el.offset().left + @$el.width() - (@span.width() / 2)

    # Make sure point snaps to the mousedown position
    @span.css
      left: e.offsetX
    @value.html @getCurrentValue().toFixed(2)

    # Then set span starting position
    startPositionLeft = @span.position().left

    $(document).on 'mousemove', (d_e) =>
      if @dragging
        deltaX = d_e.pageX - e.pageX
        if e.pageX + deltaX < borderLeft
          @span.css
            left: 0
        else if e.pageX + deltaX > borderRight
          @span.css
            left: @$el.width() - @span.width()
        else
          @span.css
            left: startPositionLeft + deltaX

        @value.html @getCurrentValue().toFixed(2)

    $(document).on 'mouseup', @onUserEndDrag

  onUserEndDrag: (e) =>
    $('body').removeClass 'unselectable'
    @dragging = false
    $(document).off 'mousemove'

  getCurrentValue: =>
    min = @model.get('validation')[0]
    max = @model.get('validation')[1]

    # Rescale span position to within range
    val = (@span.position().left - 0) * (max - min) / ((@$el.width() - @span.width()) - 0) + min
    if _.isNaN val then min else val


module.exports = Range