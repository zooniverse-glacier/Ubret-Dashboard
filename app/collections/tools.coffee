Manager = require 'modules/manager'

class Tools extends Backbone.Collection
  model: require('models/tool')
  sync: require('lib/ouroboros_sync') 

  initialize: ->
    @index = 0
    @header = 88
    @footer = 70

  url: =>
    "/dashboards/#{Manager.get('dashboardId')}/tools"

  focus: (tool) ->
    if @length is 0
      tool.updateFunc {zindex: 1}
      return
    maxZindexTool = @max((tool) -> tool.get('zindex'))
    unless tool.cid is maxZindexTool.cid
      tool.updateFunc({zindex: maxZindexTool.get('zindex') + 1})

  arrangeWindows: (layout) =>
    console.log layout
    @width = window.innerWidth
    @height = window.innerHeight - (@footer + @header)
    switch layout
      when 'maximize' then @maximize()
      when 'two-up' then @twoUp()
      when 'three-up-left' then @threeUp('left')
      when 'three-up-right' then @threeUp('right')
      when 'four-up' then @fourUp()
    @index = @incrementIndex(@index)

  maximize: =>
    tool = @at(@index)
    return unless tool?
    tool.set
      top: @header
      left: 0
      height: @height
      width: @width
    @focus(tool)

  twoUp: =>
    secondIndex = @incrementIndex(@index)
    @fullWindow(@index, 'left')
    @fullWindow(secondIndex, 'right')
    @index = @incrementIndex(@index)

  threeUp: (direction) =>
    secondIndex = @incrementIndex(@index)
    thirdIndex = @incrementIndex(secondIndex)
    halfSide = if direction is 'left' then 'right' else 'left'
    @fullWindow(@index, direction)
    @halfWindow(secondIndex, halfSide, 'top')
    @halfWindow(thirdIndex, halfSide, 'bottom')

  fourUp: =>
    secondIndex = @incrementIndex(@index)
    thirdIndex = @incrementIndex(secondIndex)
    fourthIndex = @incrementIndex(thirdIndex)
    @halfWindow(@index, 'left', 'top')
    @halfWindow(@index, 'left', 'bottom')
    @halfWindow(@index, 'right', 'top')
    @halfWindow(@index, 'right', 'bottom')
 
  fullWindow: (index, side) =>
    tool = @at(index)
    return unless tool?
    tool.set
      top: @header
      left: if side is 'left' then 0 else @width / 2
      height: @height
      width: @width / 2
    @focus(tool)
   
  halfWindow: (index, side, vertical) =>
    tool = @at(index)
    return unless tool?
    tool.set
      top: if vertical is 'top' then @header else @header + (@height / 2)
      left: if side is 'left' then 0 else @width / 2
      height: @height / 2
      width: @width / 2
    @focus(tool)
      
  incrementIndex: (index) =>
    index += 1
    if index >= @length
      index = 0
    index

module.exports = Tools
