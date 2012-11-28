Param = require 'views/param'

class Range extends Param
  template: require 'views/templates/params/range'

  events:
    'mousedown span': 'onUserStartDrag'

  render: =>
    super
    @span = @$el.find('span')
    @

  onUserStartDrag: (e) =>
    $('body').addClass 'unselectable'
    @dragging = true

    startPositionLeft = @span.position().left
    borderLeft = @$el.offset().left
    borderRight = @$el.offset().left + @$el.width()

    $(document).on 'mousemove', (d_e) =>
      if @dragging
        deltaX = d_e.pageX - e.pageX
        if e.pageX + deltaX < borderLeft
          @span.css
            left: 0
        else if e.pageX + deltaX > borderRight
          @span.css
            left: @$el.width()
        else
          @span.css
            left: startPositionLeft + deltaX

    $(document).on 'mouseup', @onUserEndDrag

  onUserEndDrag: (e) =>
    $('body').removeClass 'unselectable'
    @dragging = false
    $(document).off 'mousemove'

  getCurrentValue: =>
    min = @model.get('validation')[0]
    max = @model.get('validation')[1]

    # Rescale span position to within range
    return (@span.position().left - 0) * (max - min) / (@$el.width() - 0) + min



module.exports = Range